module Accounts
  module Owners
    class DashboardsController < ApplicationController
      layout "front"
      before_action :authenticate_owner!
      before_action :set_profile

      def show; end

      private

      def set_profile
        @profile = current_owner.profile
      end
    end
  end
end
