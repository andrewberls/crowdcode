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

  has_many :reviews
  has_many :comments

  before_create :generate_auth_token

  def self.create_from_omniauth(omniauth)
    User.new do |u|
      u.github_uid = omniauth['uid']
      u.username   = omniauth['info']['nickname']
      u.email      = omniauth['info']['email']
      u.save!
    end
  end

  def github_authenticated?
    github_uid.present?
  end

  # Redis key for vote on a specific review
  def votes_key(rid)
    "users:#{id}:votes:#{rid}"
  end

  # The vote a user has cast on a review
  # 'up', 'down', or nil
  def vote_for(rid)
    $redis.get votes_key(rid)
  end

  # Set a vote on a particular review
  # Will unset or override as necessary
  def vote(rid, dir)
    review   = Review.find_by_rid(rid)
    vkey     = votes_key(rid)
    vote     = $redis.get(vkey) # Old vote on this review (nil if none)
    opposite = (dir == 'up') ? 'down' : 'up'

    if vote.blank?
      # Old vote is blank - vote review DIR by 1 and SET user key
      review.send(:"vote_#{dir}")
      $redis.set(vkey, dir)
    elsif vote == dir
      # Old vote is same - vote review OPPOSITE by 1 and UNDO user key
     review.send(:"vote_#{opposite}")
     $redis.del(vkey)
    else
      # Old vote is opposite - vote review DIR by 2 and SET user key
      review.send(:"vote_#{dir}", 2)
      $redis.set(vkey, dir)
    end
  end

  private

  # Validate password for non-oauth users (i.e., 'regular' accounts)
  def password_for_non_oauth
    password_invalid = password_digest.blank? || password.length < 5
    if !github_authenticated? && password_invalid
      errors.add(:password, "must be at least 5 characters")
    end
  end

  def generate_auth_token
    self.auth_token = SecureRandom.urlsafe_base64
  end

end
