module Front
  class CommentsController < ApplicationController
    layout "front"

    before_action :authenticate_owner!
    before_action :set_commentable, only: [:index, :show, :new, :create]

    def index
      @pagy, @comments = pagy(
        @commentable
        .comments
        .preload(:comments, author: :profile)
        .with_rich_text_content
        .order(created_at: :asc),
        items: 10
      )
      authorize Comment, policy_class: Front::CommentPolicy
    end

    def show
      @comment = @commentable.comments.find_by(comment_token: params[:comment_token])
      authorize @comment, policy_class: Front::CommentPolicy
    end

    def new
      @comment = @commentable.comments.new
      @comment.author = current_owner
      authorize @comment, policy_class: Front::CommentPolicy
    end

    def create
      @comment = @commentable.comments.create(comment_params)
      @comment.author = current_owner
      authorize @comment, policy_class: Front::CommentPolicy

      if @comment.save
        flash[:success] = "A new comment was successfully posted."
        redirect_to [@commentable, @comment]
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def set_commentable
      @commentable = Comment.find_by(comment_token: params[:comment_id]) if params.has_key?(:comment_id)
      @commentable = Discussion.find_by(discussion_token: params[:discussion_token]) if params.has_key?(:discussion_token)
    end

    def comment_params
      params.require(:comment).permit(:content)
    end

    def pundit_user
      current_owner
    end
  end
end