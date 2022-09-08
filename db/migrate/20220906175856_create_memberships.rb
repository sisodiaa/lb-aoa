class CreateMemberships < ActiveRecord::Migration[7.0]
  def change
    create_table :memberships do |t|
      t.integer :membership_state, null: false, default: 0
      t.text :remark
      t.references :property, null: false, foreign_key: true

      t.timestamps
    end
  end
end
