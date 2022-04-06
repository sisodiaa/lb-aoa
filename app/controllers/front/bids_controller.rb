module Front
  class BidsController < ApplicationController
    layout "front"

    before_action :set_tender

    def index
      @bids = policy_scope(@tender, policy_scope_class: Front::BidPolicy::Scope)
    end

    def show
      authorize @tender, policy_class: Front::BidPolicy
      @bid = @tender.bids.find_by(quotation_token: params[:id])
      @document = @bid.document
    end

    def pundit_user
      nil
    end

    private

    def set_tender
      @tender = Tender.find(params[:tender_id])
    end
  end
end
