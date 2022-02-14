module TMS
  class SelectionsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_tender
    before_action :set_bid

    def new
      authorize @tender, policy_class: TMS::SelectionPolicy
    end

    def create
      authorize @tender, policy_class: TMS::SelectionPolicy
      @selection = Selection.new(selection_params)
      @selection.tender = @tender
      @selection.bid = @bid

      if @selection.save
        flash[:success] = "Bid selection was successful."
        redirect_to tms_tender_path(@tender)
      else
        render :new
      end
    end

    def pundit_user
      current_admin
    end

    private

    def set_tender
      @tender = Tender.find(params[:tender_id])
    end

    def set_bid
      @bid = Bid.find_by(quotation_token: params[:bid_id])
    end

    def selection_params
      params.require(:selection).permit(:reason)
    end
  end
end
