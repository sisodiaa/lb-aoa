module Front
  class TendersController < ApplicationController
    layout "front"

    def index
    end

    def published
      # pagy, posts = pagy(Post.published.order(published_at: :desc), items: 6)
    end

    def show
      @tender = Tender.find(params[:id])
    end
  end
end
