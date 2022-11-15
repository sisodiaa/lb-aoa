class AddCommentsTotalToDiscussions < ActiveRecord::Migration[7.0]
  def up
    add_column :discussions, :comments_total, :integer
    change_column_null :discussions, :comments_total, false, 0 # set value to zero for existing records
    change_column_default :discussions, :comments_total, 0
  end

  def down
    remove_column :discussions, :comments_total, :integer
  end
end
