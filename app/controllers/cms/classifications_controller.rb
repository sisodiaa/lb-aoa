module CMS
  class ClassificationsController < ApplicationController
    before_action :authenticate_admin!

    def update
      @post = Post.find(params[:id])
      @post.toggle_visibility

      if @post.save
        respond_to do |format|
          format.turbo_stream do
            flash.now[:success] = "Visibility state was successfully modified."
          end

          format.html do
            flash[:success] = "Visibility state was successfully modified."
            redirect_to cms_post_path(@post)
          end
        end
      end
    end
  end
end
