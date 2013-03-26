class Comment < ActiveRecord::Base

  attr_accessible :body, :parent_id

  belongs_to :review

  has_ancestry

end
