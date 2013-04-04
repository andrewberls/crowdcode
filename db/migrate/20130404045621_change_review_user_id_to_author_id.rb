class ChangeReviewUserIdToAuthorId < ActiveRecord::Migration
  def up
    remove_column :reviews, :user_id
    add_column :reviews, :author_id, :integer
  end

  def down
    remove_column :reviews, :author_id
    add_column :reviews, :user_id, :integer
  end
end
