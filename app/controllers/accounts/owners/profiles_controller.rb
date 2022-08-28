module Accounts
  module Owners
    class ProfilesController < ApplicationController
      layout -> { turbo_frame_request? ? false : "front" }

      before_action :turbo_frame_request_variant
      before_action :authenticate_owner!
      before_action :set_profile

      def edit; end

      def update
        if @profile.update(profile_params)
          flash[:success] = "Your profile was successfully updated."
          respond_to do |format|
            format.turbo_stream
            format.html { redirect_to owners_dashboard_path }
          end
        else
          render :edit, status: :unprocessable_entity
        end
      end

      private
      def turbo_frame_request_variant
        request.variant = :turbo_frame if turbo_frame_request?
      end

      def set_profile
        @profile = current_owner.profile
      end

      def profile_params
        params.require(:profile).permit(:first_name, :middle_name, :last_name, :phone_number)
      end
    end
  end
end
