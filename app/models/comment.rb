class Comment < ActiveRecord::Base

  attr_accessible :body, :parent_id, :author

  belongs_to :review
  belongs_to :author, class_name: 'User'

  validates :body, presence: true
  validates :review_id, presence: true
  validates :author_id, presence: true

  has_ancestry

end
