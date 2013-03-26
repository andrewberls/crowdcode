class Review < ActiveRecord::Base
  attr_accessible :title, :body

  belongs_to :user

  validates :title, presence: true

  has_many :comments

  before_create :generate_rid


  private

  def generate_rid
    begin
      self.rid = SecureRandom.hex(3)
    end while self.class.exists?(rid: rid)
  end

end
