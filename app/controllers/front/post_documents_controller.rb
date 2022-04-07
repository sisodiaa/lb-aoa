module Front
  class PostDocumentsController < ApplicationController
    layout -> { turbo_frame_request? ? false : "front" }

    def index
      @post = Post.find(params[:post_id])
      @documents = @post.documents.with_attached_file
    end
  end
end
