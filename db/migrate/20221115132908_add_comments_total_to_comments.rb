class AddCommentsTotalToComments < ActiveRecord::Migration[7.0]
  def up
    add_column :comments, :comments_total, :integer
    change_column_null :comments, :comments_total, false, 0 # set value to zero for existing records
    change_column_default :comments, :comments_total, 0
  end

  def down
    remove_column :comments, :comments_total, :integer
  end
end
