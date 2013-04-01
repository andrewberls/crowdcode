require 'authentication'

class User < ActiveRecord::Base
  include Authentication

  attr_accessible :username, :email, :password, :password_confirmation

  attr_reader :password
  validate :password_for_non_oauth

  validates :username, presence: true, length: { maximum: 50 }

  valid_email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
    presence: true,
    format: { with: valid_email_regex },
    uniqueness: { case_sensitive: false }

  before_create :generate_auth_token

  def self.create_from_omniauth(omniauth)
    User.new do |u|
      u.github_uid = omniauth['uid']
      u.username   = omniauth['info']['nickname']
      u.email      = omniauth['info']['email']
      u.save!
    end
  end

  def votes_key(rid)
    "users:#{id}:votes:#{rid}"
  end

  # The vote a user has cast on a review
  # 'up', 'down', or nil
  def vote_for(rid)
    $redis.get votes_key(rid)
  end

  # Set a vote on a particular review
  # In addition, will undo or override as necessary
  # Ex: voting up will set to up
  # Ex: voting up and then up again will undo your vote (neutralize)
  # Ex: voting up and then down will set to down
  def vote(rid, dir, amt)
    review = Review.find_by_rid(rid)
    vkey   = votes_key(rid)
    vote   = $redis.get(vkey)
    # opposite = (dir == 'up') ? 'down' : 'up'

    puts "old vote: #{vote}, dir: #{dir}"

    if vote.blank? || vote != dir
      # No previous vote or overriding opposite (up -> down)
      puts "===> BLANK set to #{dir}" if vote.blank?
      puts "===> OVERRIDE change #{vote} to #{dir}" if vote.present? && vote != dir
      $redis.set(vkey, dir)
      (dir == 'up') ? review.vote_up(amt) : review.vote_down(amt)
    else
      # Same - undo
      puts "===> SAME undoing #{vote} with opposite (del key)"
      $redis.del(vkey)
      (vote == 'up') ? review.vote_down(amt) : review.vote_up(amt)

    end
  end


  private

  # Validate password for non-oauth users (i.e., 'regular' accounts)
  def password_for_non_oauth
    password_invalid = password_digest.blank? || password.length < 5
    if github_uid.blank? && password_invalid
      errors.add(:password, "must be at least 5 characters")
    end
  end

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

end
