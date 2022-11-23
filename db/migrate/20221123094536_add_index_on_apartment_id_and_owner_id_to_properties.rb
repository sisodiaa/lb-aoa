class AddIndexOnApartmentIdAndOwnerIdToProperties < ActiveRecord::Migration[7.0]
  def change
    add_index :properties, [:apartment_id, :owner_id], unique: true
  end
end
