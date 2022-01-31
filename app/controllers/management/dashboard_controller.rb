module Management
  class DashboardController < ApplicationController
    before_action :authenticate_admin!

    def index
      @drafts = Post.draft.order(created_at: :asc)
      @published_posts = Post.published.order(published_at: :desc)
    end
  end
end
