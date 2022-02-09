module Front
  class TendersController < ApplicationController
    layout "front"

    def index
      @page = params[:page] || 1
      @status = params[:status] || "upcoming"
    end

    def tenders
      @status = params[:status]
      @pagy, @tenders = pagy(published_tenders.order(published_at: :desc), items: 6)
    end

    def show
      @tender = Tender.find(params[:id])
    end

    private

    def published_tenders
      Tender.published.try!(params[:status].to_sym)
    rescue NoMethodError
      Tender.none
    end
  end
end
