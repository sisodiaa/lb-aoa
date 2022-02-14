class CreateSelections < ActiveRecord::Migration[7.0]
  def change
    create_table :selections do |t|
      t.text :reason
      t.references :tender, null: false, foreign_key: true
      t.references :bid, null: false, foreign_key: true

      t.timestamps
    end
  end
end
