module Front
  class PostsController < ApplicationController
    layout -> { turbo_frame_request? ? false : "front" }

    def index
      @page = params[:page] || 1
    end

    def published
      @pagy, @posts = pagy(
        Post
          .published
          .includes(:category, :rich_text_content)
          .order(published_at: :desc),
        items: 6
      )
    end

    def show
      @post = Post.find(params[:id])
      @tags = @post.tags
    end
  end
end
