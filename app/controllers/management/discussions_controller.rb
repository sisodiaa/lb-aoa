module Management
  class DiscussionsController < ApplicationController
    before_action :authenticate_admin!

    def index
      @pagy, @discussions = pagy(Discussion.all.order(created_at: :desc), items: 10)
    end

    def update
      @discussion = Discussion.find_by(discussion_token: params[:discussion_token])
      @discussion.toggle_accessibility

      if @discussion.save
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
      end
    end
  end
end
