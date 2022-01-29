module CMS
  class PostsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_post, only: [:show, :edit, :update, :destroy]

    def index
      @posts = Post.all
    end

    def show; end

    def new
      @post = Post.new
    end

    def create
      @post = Post.new(post_params)

      if @post.save
        redirect_to cms_post_path(@post), notice: "Post was successfully created."
      else
        respond_to do |format|
          format.turbo_stream do
            render :new
          end
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def edit
      authorize @post, policy_class: CMS::PostPolicy
    end

    def update
      authorize @post, policy_class: CMS::PostPolicy

      if @post.update(post_params)
        redirect_to cms_post_path(@post), notice: "Post was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @post, policy_class: CMS::PostPolicy

      respond_to do |format|
        if @post.destroy
          format.turbo_stream do
            flash.now[:notice] = "Post was successfully destroyed."
          end
          format.html do
            flash[:notice] = "Post was successfully destroyed."
            redirect_to cms_posts_url, status: :see_other
          end
        end
      end
    end

    def pundit_user
      current_admin
    end

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content)
    end
  end
end
