module Management
  module Search
    class ApartmentsController < ApplicationController
      before_action :authenticate_admin!
      before_action :set_apartments_form

      def index
        if @apartments_form.valid?
          @apartments = @apartments_form.search
        else
          render :index, status: :unprocessable_entity
        end
      end

      private

      def set_apartments_form
        @apartments_form = Management::Search::ApartmentsForm.new(params)
      end
    end
  end
end
