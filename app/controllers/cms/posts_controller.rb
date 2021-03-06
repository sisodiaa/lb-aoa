module CMS
  class PostsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_post, only: [:show, :edit, :update, :destroy]

    def index
      @status = params[:status]
      @pagy, @posts = pagy(posts_list, items: 5)

      respond_to do |format|
        format.turbo_stream
        format.html
      end
    end

    def show
      @tags = @post.tags
    end

    def new
      @post = Post.new
    end

    def create
      @post = Post.new(post_params)

      if @post.save
        flash[:success] = "Post was successfully created."
        redirect_to cms_post_path(@post)
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @post, policy_class: CMS::PostPolicy
    end

    def update
      authorize @post, policy_class: CMS::PostPolicy

      respond_to do |format|
        if @post.update(post_params)
          format.turbo_stream do
            @tags = @post.tags
            flash.now[:success] = "Post was successfully updated."
          end

          format.html do
            flash[:success] = "Post was successfully updated."
            redirect_to cms_post_path(@post)
          end
        else
          format.turbo_stream { render :edit }
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize @post, policy_class: CMS::PostPolicy

      respond_to do |format|
        if @post.documents.with_attached_file.destroy_all && @post.destroy
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

    def posts_list
      if params[:status] == "draft"
        Post.draft.order(created_at: :asc)
      elsif params[:status] == "published"
        Post.published.order(published_at: :desc)
      else
        Post.all.order(created_at: :asc)
      end
    end

    def set_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :content, :category_id, :tags_list)
    end
  end
end
