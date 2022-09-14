module Management
  module Search
    class OwnersController < ApplicationController
      before_action :authenticate_admin!
      before_action :set_owners_form

      def index
        if @owners_form.valid?
          @owners = @owners_form.search
        else
          render :index, status: :unprocessable_entity
        end
      end

      private

      def set_owners_form
        @owners_form = Management::Search::OwnersForm.new(params)
      end
    end
  end
end
