module Management
  module Search
    class OwnersForm
      include ActiveModel::API

      attr_accessor :email

      def initialize(attributes = {})
        @email = attributes.fetch(:email, nil)
      end

      validate :email_address

      def email_address
        errors.add(:email, "can not be blank") if email == ""
      end

      def search
        Owner.where(email: email)
      end
    end
  end
end
