class Comment < ActiveRecord::Base
  attr_accessible :body, :parent_id
  has_ancestry
end
