module Front
  class PostsController < ApplicationController
    layout "front"

    def index
      @page = params[:page] || 1
    end

    def published
      @pagy, @posts = pagy(Post.published.order(published_at: :desc), items: 6)
    end

    def show
      @post = Post.find(params[:id])
    end
  end
end
