class Review < ActiveRecord::Base
  attr_accessible :body, :rid, :title
  belongs_to :user

  validates :title,
    presence: true
end
