module Front
  class PostDocumentsController < ApplicationController
    def index
      @post = Post.find(params[:post_id])
      @documents = @post.documents.with_attached_file
    end
  end
end
