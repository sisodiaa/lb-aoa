module Management
  class DashboardController < ApplicationController
    before_action :authenticate_admin!

    def index
      @drafts_count = Post.draft.count
      @published_posts_count = Post.published.count
      @categories_count = Category.count
    end
  end
end
