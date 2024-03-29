module Accounts
  module Owners
    class PropertiesController < ApplicationController
      before_action :authenticate_owner!
      before_action :set_properties, only: [:index, :create, :update]
      before_action :set_property, only: [:show, :edit, :update]

      layout -> { turbo_frame_request? ? false : "front" }

      def index
      end

      def show; end

      def new
        @property_form = Accounts::Owners::PropertyForm.new
      end

      def create
        @property_form = Accounts::Owners::PropertyForm.new(
          property_params.merge!(owner_id: current_owner.id)
        )

        if @property_form.save
          flash[:success] = "Your Property record was successfully saved."
          respond_to do |format|
            format.turbo_stream
            format.html { redirect_to owners_properties_path }
          end
        else
          render :new, status: :unprocessable_entity
        end
      end

      def edit
        authorize @property

        @property_form = Accounts::Owners::PropertyForm.new(
          tower_number: @property.apartment.tower_number,
          flat_number: @property.apartment.flat_number,
          purchased_on: @property.purchased_on || "",
          registration: @property.registered,
          primary_ownership: @property.primary_owner
        )
      end

      def update
        authorize @property

        @property_form = Accounts::Owners::PropertyForm.new(
          property_token: @property.property_token,
          tower_number: property_params[:tower_number] || @property.apartment.tower_number,
          flat_number: property_params[:flat_number] || @property.apartment.flat_number,
          purchased_on: property_params[:purchased_on] || @property.purchased_on,
          registration: property_params[:registered] || @property.registered,
          primary_ownership: property_params[:primary_owner] || @property.primary_owner
        )

        if @property_form.update
          flash[:success] = "Your Property record was successfully updated."
          respond_to do |format|
            format.turbo_stream
            format.html { redirect_to owners_properties_path }
          end
        else
          render :edit, status: :unprocessable_entity
        end
      end

      def pundit_user
        current_owner
      end

      private

      def set_properties
        @properties = current_owner
          .properties
          .includes(:apartment, :membership)
          .order("purchased_on ASC")
      end

      def set_property
        @property = current_owner.properties.find_by(property_token: params[:property_token])
        redirect_to root_path if @property.nil?
      end

      def property_params
        params
          .require(:property)
          .permit(:tower_number, :flat_number, :purchased_on, :registration, :primary_ownership)
      end
    end
  end
end
