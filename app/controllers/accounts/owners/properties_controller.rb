module Accounts
  module Owners
    class PropertiesController < ApplicationController
      before_action :authenticate_owner!
      before_action :set_properties, only: [:index, :create]
      before_action :set_property, only: :show

      layout -> { turbo_frame_request? ? false : "front" }

      def index
      end

      def show; end

      def new
        @property = Accounts::Owners::PropertyForm.new
      end

      def create
        @property = Accounts::Owners::PropertyForm.new(
          property_params.merge!(owner_id: current_owner.id)
        )

        if @property.save
          flash[:success] = "Your Property record was successfully saved."
          respond_to do |format|
            format.turbo_stream
            format.html { redirect_to owners_properties_path }
          end
        else
          render :new, status: :unprocessable_entity
        end
      end

      private

      def set_properties
        @properties = current_owner
          .properties
          .includes(:apartment)
          .order("purchased_on ASC")
      end

      def set_property
        @property = current_owner.properties.find_by(property_token: params[:property_token])
      end

      def property_params
        params
          .require(:property)
          .permit(:tower_number, :flat_number, :purchased_on, :registered, :primary_owner)
      end
    end
  end
end
