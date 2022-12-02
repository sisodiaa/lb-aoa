module Management
  class DiscussionsController < ApplicationController
    before_action :authenticate_admin!

    def index
      @pagy, @discussions = pagy(Discussion.all.order(created_at: :desc), items: 10)
    end

    def update
      @discussion = Discussion.find_by(discussion_token: params[:discussion_token])
      @discussion.toggle_accessibility if discussion_accessibility_toggable?

      if @discussion.accessibility_state_changed? && @discussion.save
        respond_to do |format|
          format.turbo_stream do
            flash.now[:success] = "Accessibility state was successfully modified."
            render "management/discussions/update"
          end

          format.html do
            flash[:success] = "Accessibility state was successfully modified."
            redirect_to management_discussions_path
          end
        end
      else
        @pagy, @discussions = pagy(Discussion.all.order(created_at: :desc), items: 10)
        render :index, status: :unprocessable_entity
      end
    end

    private

    def discussion_params
      params.require(:discussion).permit(:accessibility_state)
    end

    def discussion_accessibility_toggable?
      discussion_params.has_key?(:accessibility_state) && (
        discussion_params[:accessibility_state] == "locked" ||
        discussion_params[:accessibility_state] == "unlocked"
      )
    end
  end
end
