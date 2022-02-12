module TMS
  class BidsController < ApplicationController
    before_action :set_tender

    def new
      authorize @tender, policy_class: TMS::BidPolicy
      @bid = @tender.bids.new
      @bid.build_document
    end

    def create
      authorize @tender, policy_class: TMS::BidPolicy

      @bid = @tender.bids.build(bid_params)

      respond_to do |format|
        if @bid.save
          format.turbo_stream do
            flash.now[:success] = "Bid was successfully submitted."
          end

          format.html do
            flash[:success] = "Bid was successfully submitted."
            redirect_to tender_path(@tender)
          end
        else
          format.turbo_stream do
            flash.now[:error] = "Bid was not created. Try again!"
            render :new
          end

          format.html do
            flash[:error] = "Bid was not created. Try again!"
            render :new, status: :unprocessable_entity
          end
        end
      end
    end

    def pundit_user
      nil
    end

    private

    def set_tender
      @tender = Tender.find(params[:tender_id])
    end

    def bid_params
      params.require(:bid).permit(:name, :email, :note, document_attributes: [:file, :annotation])
    end
  end
end
