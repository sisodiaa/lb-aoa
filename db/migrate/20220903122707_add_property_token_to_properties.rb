class AddPropertyTokenToProperties < ActiveRecord::Migration[7.0]
  def change
    add_column :properties, :property_token, :string
    add_index :properties, :property_token, unique: true
  end
end
