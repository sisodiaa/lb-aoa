module Accounts
  module Owners
    class PropertiesController < ApplicationController
      before_action :authenticate_owner!

      layout -> { turbo_frame_request? ? false : "front" }

      def index
        @properties = current_owner
          .properties
          .includes(:apartment)
          .order("purchased_on ASC")
      end
    end
  end
end
