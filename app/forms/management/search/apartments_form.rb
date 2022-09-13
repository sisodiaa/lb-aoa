module Management
  module Search
    class ApartmentsForm
      include ActiveModel::API

      attr_accessor :tower_number, :flat_number

      def initialize(attributes = {})
        @tower_number = attributes.fetch(:tower_number, nil)
        @flat_number = attributes.fetch(:flat_number, nil)
      end

      validate :apartment_tower_number, :apartment_flat_number

      def apartment_tower_number
        errors.add(:tower_number, "can not be blank") if tower_number == ""
      end

      def apartment_flat_number
        errors.add(:flat_number, "can not be blank") if flat_number == ""
      end

      def search
        Apartment.where(tower_number: tower_number, flat_number: flat_number)
      end
    end
  end
end
