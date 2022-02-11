class CreateBids < ActiveRecord::Migration[7.0]
  def change
    create_table :bids do |t|
      t.string :name
      t.string :email
      t.string :quotation_token
      t.text :note
      t.references :tender, null: false, foreign_key: true

      t.timestamps
    end

    add_index :bids, :quotation_token, unique: true
    add_index :bids, [:email, :tender_id], unique: true
  end
end
