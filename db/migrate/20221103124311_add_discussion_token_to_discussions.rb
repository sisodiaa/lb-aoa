class AddDiscussionTokenToDiscussions < ActiveRecord::Migration[7.0]
  def change
    # Do not use null: false if records for model already exists,
    # use change_column_null as advised in
    # https://www.viget.com/articles/adding-a-not-null-column-to-an-existing-table/
    add_column :discussions, :discussion_token, :string, null: false
    add_index :discussions, :discussion_token, unique: true
  end
end
