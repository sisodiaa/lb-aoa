class RemoveRedundantApartmentOwnerCombinationRecordsFromProperties < ActiveRecord::Migration[7.0]
  def up
    redundant_combinations = Property
      .select(:apartment_id, :owner_id)
      .group(:apartment_id, :owner_id)
      .having("count(*) > 1")

    redundant_combinations.each do |combination|
      properties = Property
        .joins(:membership)
        .where(
          apartment_id: combination.apartment_id,
          owner_id: combination.owner_id,
          membership: {membership_state: :under_review}
        )
        .order(created_at: :asc)
      properties = properties.where.not(id: properties.first)
      properties.destroy_all
    end
  end
end
