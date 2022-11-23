module Accounts
  module Owners
    class PropertyForm
      include ActiveModel::API

      attr_accessor :owner_id, :property_token, :tower_number, :flat_number, :purchased_on, :registration, :primary_ownership

      def initialize(attributes = {})
        @owner_id = attributes.fetch(:owner_id, "")
        @property_token = attributes.fetch(:property_token, "")
        @tower_number = attributes.fetch(:tower_number, "")
        @flat_number = attributes.fetch(:flat_number, "")
        @purchased_on = attributes.fetch(:purchased_on, "").to_date
        @registration = ActiveModel::Type::Boolean.new.cast(attributes.fetch(:registration, ""))
        @primary_ownership = ActiveModel::Type::Boolean.new.cast(attributes.fetch(:primary_ownership, ""))
      end

      def save
        if valid?(:create)
          ActiveRecord::Base.transaction do
            apartment = Apartment
              .where(tower_number: tower_number, flat_number: flat_number)
              .first_or_create

            property = Property.create(
              owner_id: owner_id,
              apartment_id: apartment.id,
              purchased_on: purchased_on,
              registered: registration,
              primary_owner: primary_ownership
            )

            owner = Owner.find(owner_id)
            owner.link! if owner.unlinked?

            property.create_membership!
          end
          true
        else
          false
        end
      end

      def update
        if valid?(:update)
          property = Property.find_by(property_token: property_token)

          ActiveRecord::Base.transaction do
            apartment = if property.tower_number != tower_number || property.flat_number != flat_number
              Apartment
                .where(tower_number: tower_number, flat_number: flat_number)
                .first_or_create
            else
              property.apartment
            end

            old_apartment = property.apartment

            property.update(
              apartment_id: apartment.id,
              purchased_on: purchased_on,
              registered: registration,
              primary_owner: primary_ownership
            )

            if apartment != old_apartment && old_apartment.properties.count.zero?
              old_apartment.destroy
            end

            property.membership.scrutinize!
          end

          true
        else
          false
        end
      end

      # Validations

      validates :owner_id, presence: true, on: :create
      validates :property_token, presence: true, on: :update
      validates :tower_number, presence: true
      validates :flat_number, presence: true
      validates :purchased_on, presence: true
      validate :purchased_on_date_cannot_be_in_the_future
      validate :combination_of_owner_and_apartment_is_unique
      validates :registration, inclusion: {
        in: [true, false],
        message: "status should be either \"Yes\" or \"No\""
      }
      validates :primary_ownership, inclusion: {
        in: [true, false],
        message: "status should be either \"Yes\" or \"No\""
      }

      private

      def purchased_on_date_cannot_be_in_the_future
        errors.add(:purchased_on, "date is invalid as it is set in future") if purchased_on.try(:future?)
      end

      def combination_of_owner_and_apartment_is_unique
        errors.add(:property, "already listed by this account") if combination_of_owner_and_apartment_exists?
      end

      def combination_of_owner_and_apartment_exists?
        apartment = Apartment.where(tower_number: tower_number, flat_number: flat_number)
        apartment.exists? && Property.where(owner_id: owner_id, apartment_id: apartment.first.id).exists?
      end
    end
  end
end
