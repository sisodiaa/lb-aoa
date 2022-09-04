module Accounts
  module Owners
    class PropertyForm
      include ActiveModel::API

      attr_accessor :tower_number, :flat_number, :purchased_on, :registration, :primary_ownership

      def initialize(attributes = {})
        @tower_number = attributes.fetch(:tower_number, "")
        @flat_number = attributes.fetch(:flat_number, "")
        @purchased_on = attributes.fetch(:purchased_on, "")
      end

      # Validations

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
