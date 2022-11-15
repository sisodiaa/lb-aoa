module Front
  class DiscussionsController < ApplicationController
    layout "front"

    before_action :authenticate_owner!

    def index
      @pagy, @discussions = pagy(
        Discussion.order(created_at: :desc),
        items: 10
      )
      authorize Discussion, policy_class: Front::DiscussionPolicy
    end

    def show
      @discussion = Discussion.find_by(discussion_token: params[:discussion_token])
      authorize @discussion, policy_class: Front::DiscussionPolicy
    end

    def new
      @discussion = current_owner.discussions.new
      authorize @discussion, policy_class: Front::DiscussionPolicy
    end

    def create
      @discussion = current_owner.discussions.create(discussion_params)
      authorize @discussion, policy_class: Front::DiscussionPolicy

      if @discussion.save
        flash[:success] = "A new discussion topic was successfully created."
        redirect_to @discussion
      else
        render action: :new, status: :unprocessable_entity
      end
    end

    private

    def discussion_params
      params.require(:discussion).permit(:subject, :description)
    end

    def pundit_user
      current_owner
    end
  end
end
