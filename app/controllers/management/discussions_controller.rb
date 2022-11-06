module Management
  class DiscussionsController < ApplicationController
    before_action :authenticate_admin!

    def index
      @pagy, @discussions = pagy(Discussion.all.order(created_at: :desc), items: 10)
    end
  end
end
