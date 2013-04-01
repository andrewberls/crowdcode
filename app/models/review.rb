class Review < ActiveRecord::Base
  attr_accessible :title, :body

  belongs_to :user

  validates :title, presence: true

  has_many :comments

  before_create :generate_rid


  # Cache the redis key for votes
  # Ex: reviews:2:votes
  def votes_key
    @votes_key ||= "reviews:#{rid}:votes"
  end

  def votes
    $redis.get(votes_key).to_i || 0
  end

  def vote_up(amt=1)
    puts "=======> REVIEW vote_up by #{amt}"
    $redis.incrby(votes_key, amt)
  end

  def vote_down(amt=1)
    puts "=======> REVIEW vote_down by #{amt}"
    $redis.decrby(votes_key, amt)
  end

  private

  def generate_rid
    begin
      self.rid = SecureRandom.hex(3)
    end while self.class.exists?(rid: rid)
  end

end
