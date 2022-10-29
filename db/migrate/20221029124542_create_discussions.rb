class CreateDiscussions < ActiveRecord::Migration[7.0]
  def change
    create_table :discussions do |t|
      t.string :subject
      t.integer :accessibility_state, null: false, default: 0
      t.references :owner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
