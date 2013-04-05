class Review < ActiveRecord::Base

  attr_accessible :title, :body, :author

  belongs_to :author, class_name: 'User'

  # TODO: improve these
  validates :title, presence: true, length: { minimum: 5 }
  validates :body, presence: true
  validates :author, presence: true

  has_many :comments

  before_create :generate_rid

  searchable do
    text :title, :body
    text :author do
      author.username
    end
    text :comments do
      comments.pluck(:body)
    end
    time :created_at
  end

  # Cache the redis key for votes
  # Ex: reviews:2:votes
  def votes_key
    @votes_key ||= "reviews:#{rid}:votes"
  end

  def votes
    $redis.get(votes_key).to_i || 0
  end

  def vote_up(amt = 1)
    $redis.incrby(votes_key, amt)
  end

  def vote_down(amt = 1)
    $redis.decrby(votes_key, amt)
  end

  private

  def generate_rid
    begin
      self.rid = SecureRandom.hex(3)
    end while self.class.exists?(rid: rid)
  end

end
