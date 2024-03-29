module Accounts
  module Owners
    class DashboardsController < ApplicationController
      layout -> { turbo_frame_request? ? false : "front" }

      before_action :authenticate_owner!
      before_action :set_profile

      def show; end
      def account; end
      def profile; end

      def properties
        @properties = current_owner
          .properties
          .includes(:apartment, :membership)
          .order("purchased_on ASC")
      end

      private

      def set_profile
        @profile = current_owner.profile
      end
    end
  end
end
