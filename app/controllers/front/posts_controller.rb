module Front
  class PostsController < ApplicationController
    layout -> { turbo_frame_request? ? false : "front" }

    def index
      @page = params[:page] || 1
    end

    def published
      # You don’t need to explicitly pass the page number to the pagy method,
      # because it is pulled in by the pagy_get_vars
      @pagy, @posts = pagy(
        policy_scope(Post, policy_scope_class: Front::PostPolicy::Scope),
        items: 6
      )
    end

    def show
      @post = Post.find(params[:id])
      authenticate_and_authorize_owner if @post.members?
      @tags = @post.tags
    end

    def pundit_user
      current_owner
    end

    private

    def authenticate_and_authorize_owner
      authenticate_owner!
      authorize @post, policy_class: Front::PostPolicy
    end
  end
end
