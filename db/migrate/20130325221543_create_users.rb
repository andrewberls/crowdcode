class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :auth_token
      t.string :password_digest
      t.string :username
      t.string :github_uid

      t.timestamps
    end
  end
end
