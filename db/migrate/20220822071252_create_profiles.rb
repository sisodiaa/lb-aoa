class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.string :phone_number
      t.references :owner, null: false, foreign_key: true

      t.timestamps
    end
  end
end
