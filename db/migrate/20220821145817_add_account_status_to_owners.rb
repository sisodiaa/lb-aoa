class AddAccountStatusToOwners < ActiveRecord::Migration[7.0]
  def change
    add_column :owners, :account_status, :integer, null: false, default: 0
  end
end
