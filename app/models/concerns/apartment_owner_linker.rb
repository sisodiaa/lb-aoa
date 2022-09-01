module ApartmentOwnerLinker
  extend ActiveSupport::Concern

  module ClassMethods
    def link_owner_and_apartment(owner, params)
      apartment = Apartment.new(
        tower_number: params[:tower_number],
        flat_number: params[:flat_number]
      )

      property = Property.new(
        purchased_on: params[:purchased_on],
        registered: params[:registered],
        primary_owner: params[:primary_owner]
      )

      ActiveRecord::Base.transaction do
        apartment.save!
        property.apartment_id = apartment.id
        property.owner_id = owner.id
        property.save!
      end

      property
    end
  end
end
