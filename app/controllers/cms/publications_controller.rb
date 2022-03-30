module CMS
  class PublicationsController < ApplicationController
    before_action :authenticate_admin!

    def update
      @post = Post.find(params[:id])

      authorize @post, policy_class: CMS::PublicationPolicy

      @post.publish if params.dig(:post, :publication_state) == "published"
      @post.published_at = Time.current

      @post.published? && respond_to do |format|
        if @post.save
          format.turbo_stream do
            flash[:success] = "Post was successfully published."
          end

          format.html do
            flash[:success] = "Post was successfully published."
            redirect_to cms_post_path(@post)
          end
        end
      end
    end

    def pundit_user
      current_admin
    end
  end
end
