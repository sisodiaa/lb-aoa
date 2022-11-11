class AddCommentTokentoComments < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :comment_token, :string, null: false
    add_index :comments, :comment_token, unique: true
  end
end
