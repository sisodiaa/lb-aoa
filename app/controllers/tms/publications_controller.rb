module TMS
  class PublicationsController < ApplicationController
    before_action :authenticate_admin!
    rescue_from AASM::InvalidTransition, with: :unpublishable

    def update
      @tender = Tender.find(params[:id])

      authorize @tender, policy_class: TMS::PublicationPolicy

      @tender.publish if publishable?

      respond_to do |format|
        if @tender.published? && @tender.save
          format.turbo_stream do
            flash.now[:success] = "Tender was successfully published."
          end

          format.html do
            flash[:success] = "Tender was successfully published."
            redirect_to tms_tender_path(@tender)
          end
        else
          format.turbo_stream do
            flash.now[:error] = "Tender was not published."
          end

          format.html do
            flash[:error] = "Tender was not published."
            render "tms/tender#show", status: :unprocessable_entity
          end
        end
      end
    end

    def pundit_user
      current_admin
    end

    private

    def publishable?
      params.dig(:tender, :publication_state) == "published" &&
        @tender.valid?(:notice_publication)
    end

    def unpublishable
      respond_to do |format|
        format.turbo_stream do
          flash.now[:error] = "Tender was not published."
          render :update
        end

        format.html do
          flash[:error] = "Tender was not published."
          render "tms/tender#show", status: :unprocessable_entity
        end
      end
    end
  end
end
