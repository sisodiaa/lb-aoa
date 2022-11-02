module Front
  class DiscussionsController < ApplicationController
    layout "front"

    before_action :authenticate_owner!

    def index
    end

    def show
      @discussion = Discussion.find(params[:id])
    end

    def new
      @discussion = current_owner.discussions.new
    end

    def create
      @discussion = current_owner.discussions.create(discussion_params)

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
  end
end