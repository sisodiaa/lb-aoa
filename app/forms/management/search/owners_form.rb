module Management
  module Search
    class OwnersForm
      include ActiveModel::API

      attr_accessor :email, :first_name, :last_name

      def initialize(attributes = {})
        @email = attributes.fetch(:email, nil)
        @first_name = attributes.fetch(:first_name, nil)
        @last_name = attributes.fetch(:last_name, nil)
      end

      validate :owner_details

      def owner_details
        errors.add(:base, "Email address, First Name, or Last Name is required") if details_missing?
      end

      def search
        results = Owner.includes(:profile)
        results = results.where(email: email.downcase) if email.present?

        if first_name.present?
          results = results.where("profiles.first_name ILIKE ?", first_name).references(:profiles)
        end

        if last_name.present?
          results = results.where("profiles.last_name ILIKE ?", last_name).references(:profiles)
        end

        results
      end

      def details_missing?
        email.blank? && first_name.blank? && last_name.blank?
      end
    end
  end
end
