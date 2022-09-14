module Management
  module Apartments
    class MembershipsController < ApplicationController
      before_action :authenticate_admin!

      def index
        @apartment = Apartment.find(params[:apartment_id])
        @status = nil
        @pagy, @memberships = pagy(memberships_list, items: 10)

        render "management/memberships/index"
      end

      private

      def memberships_list
        Membership
          .includes(property: [:apartment, {owner: [:profile]}])
          .where(property: {apartment_id: @apartment.id})
      end
    end
  end
end
