module Management
  module Search
    class OwnersController < ApplicationController
      before_action :authenticate_admin!
      before_action :set_owners_form

      def index
        if params_present? && @owners_form.valid?
          @owners = @owners_form.search
        else
          render :index, status: :unprocessable_entity
        end
      end

      private

      def set_owners_form
        @owners_form = Management::Search::OwnersForm.new(params)
      end

      def params_present?
        params.has_key?(:email) || params.has_key?(:first_name) || params.has_key?(:last_name)
      end
    end
  end
end
