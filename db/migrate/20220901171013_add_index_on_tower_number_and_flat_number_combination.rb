class AddIndexOnTowerNumberAndFlatNumberCombination < ActiveRecord::Migration[7.0]
  def change
    add_index :apartments, [:tower_number, :flat_number], unique: true
  end
end
