module CMS
  class PostsController < ApplicationController
    before_action :set_post, only: [:show, :edit, :update, :destroy]

    def index; end

    def show; end

    def new; end

    def create
      @post = Post.new(post_params)

      if @post.save
        redirect_to cms_post_path(@post), notice: "Post was successfully created."
      else
        render :new
      end
    end

    def edit; end

    def update
      if @post.update(post_params)
        redirect_to cms_post_path(@post), notice: "Post was successfully updated."
      else
        render :edit
      end
    end

    def destroy
      @post.destroy
      redirect_to cms_posts_url, notice: "Post was successfully destroyed."
    end

    private
    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title)
    end
  end
end
