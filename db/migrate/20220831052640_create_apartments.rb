class CreateApartments < ActiveRecord::Migration[7.0]
  def change
    create_table :apartments do |t|
      t.string :tower_number, null: false
      t.string :flat_number, null: false

      t.timestamps
    end
  end
end
