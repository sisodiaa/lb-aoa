module Front
  module Search
    class PostsController < ApplicationController
      layout -> { turbo_frame_request? ? false : "front" }

      before_action :set_post_form

      def index
        unless @post_form.valid?
          render(
            turbo_stream: turbo_stream.replace(
              @post_form,
              partial: "form",
              locals: {post_form: @post_form}
            ),
            status: :unprocessable_entity,
            content_type: "text/vnd.turbo-stream.html"
          )
        end
      end

      def new
      end

      private

      def set_post_form
        @post_form = Front::Search::PostForm.new(params)
      end
    end
  end
end
