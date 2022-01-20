class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.integer :publication_state, null: false, default: 0
      t.integer :visibility_state, null: false, default: 0
      t.datetime :published_at

      t.timestamps
    end
  end
end
