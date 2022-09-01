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

      def create
        @property = Property.link_owner_and_apartment(current_owner, property_params)

        if @property.valid?
          flash[:success] = "Property was successfully recorded."
          redirect_to owners_properties_path
        else
          render :new, status: :unprocessable_entity
        end
      end

      private

      def property_params
        params.require(:property).permit(:tower_number, :flat_number, :purchased_on, :registered, :primary_owner)
      end
    end
  end
end
