module CMS
  class PostsController < ApplicationController
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

    def edit; end

    def update
      if @post.update(post_params)
        redirect_to cms_post_path(@post), notice: "Post was successfully updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
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

    private

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content)
    end
  end
end
