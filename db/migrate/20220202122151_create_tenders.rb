class CreateTenders < ActiveRecord::Migration[7.0]
  def change
    create_table :tenders do |t|
      t.string :reference_id, null: false
      t.string :reference_token, null: false
      t.string :title, null: false
      t.datetime :published_at
      t.datetime :opening
      t.datetime :closing
      t.integer :notice_state, null: false, default: 0
      t.integer :publication_state, null: false, default: 0

      t.timestamps
    end

    add_index :tenders, :reference_id, unique: true
  end
end
