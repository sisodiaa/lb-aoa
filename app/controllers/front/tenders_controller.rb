module Front
  class TendersController < ApplicationController
    layout "front"

    def index
      @page = params[:page] || 1
      @status = params[:status] || "upcoming"
    end

    def published
      @pagy, @tenders = pagy(published_tenders.order(published_at: :desc), items: 6)
      @status = status.to_s
    end

    def show
      @tender = Tender.find(params[:id])
    end

    private

    def published_tenders
      Tender.published.try!(status)
    end

    def status
      (params[:status] || "upcoming").to_sym
    end
  end
end
