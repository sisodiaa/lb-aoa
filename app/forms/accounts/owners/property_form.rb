module Accounts
  module Owners
    class PropertyForm
      include ActiveModel::API

      attr_accessor :owner_id, :tower_number, :flat_number, :purchased_on, :registration, :primary_ownership

      def initialize(attributes = {})
        @owner_id = attributes.fetch(:owner_id, "")
        @tower_number = attributes.fetch(:tower_number, "")
        @flat_number = attributes.fetch(:flat_number, "")
        @purchased_on = attributes.fetch(:purchased_on, "").to_date
        @registration = ActiveModel::Type::Boolean.new.cast(attributes.fetch(:registered, ""))
        @primary_ownership = ActiveModel::Type::Boolean.new.cast(attributes.fetch(:primary_owner, ""))
      end

      def save
        if valid?
          ActiveRecord::Base.transaction do
            apartment = Apartment
              .where(tower_number: tower_number, flat_number: flat_number)
              .first_or_create

            Property.create(
              owner_id: owner_id,
              apartment_id: apartment.id,
              purchased_on: purchased_on,
              registered: registration,
              primary_owner: primary_ownership
            )
          end
        end
      end

      # Validations

      validates :owner_id, presence: true
      validates :tower_number, presence: true
      validates :flat_number, presence: true
      validates :purchased_on, presence: true
      validate :purchased_on_date_cannot_be_in_the_future
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
    end
  end
end
