module Accounts
  module Owners
    class ProfilesController < ApplicationController
      layout "front"
      before_action :authenticate_owner!
      before_action :set_profile

      def show; end

      def edit; end

      def update
        if @profile.update(profile_params)
          flash[:success] = "Your profile was successfully updated."
          redirect_to owners_profile_path
        else
          render :edit, status: :unprocessable_entity
        end
      end

      private

      def set_profile
        @profile = current_owner.profile
      end

      def profile_params
        params.require(:profile).permit(:first_name, :middle_name, :last_name, :phone_number)
      end
    end
  end
end
