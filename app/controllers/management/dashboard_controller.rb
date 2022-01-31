module Management
  class DashboardController < ApplicationController
    before_action :authenticate_admin!

    def index
      @drafts = Post.draft.order(created_at: :asc)
      @published_posts = Post.published.order(published_at: :desc)
    end

    def drafts
      @pagy, @posts = pagy(Post.draft.order(created_at: :asc), items: 10)
    end

    def published_posts
      @pagy, @posts = pagy(Post.published.order(published_at: :desc), items: 10)
    end
  end
end
