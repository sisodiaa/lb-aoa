module Management
  module Owners
    class MembershipsController < ApplicationController
      before_action :authenticate_admin!

      def index
        @owner = Owner.find(params[:owner_id])
        @status = nil
        @pagy, @memberships = pagy(memberships_list, items: 10)

        render "management/memberships/index"
      end

      private

      def memberships_list
        Membership
          .includes(property: [:apartment, {owner: [:profile]}])
          .where(property: {owner_id: @owner.id})
      end
    end
  end
end
