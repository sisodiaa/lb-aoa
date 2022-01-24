module CMS
  class PostDocumentsController < ApplicationController
    before_action :set_post

    def index
      @document = @post.documents.new
    end

    def create
      @document = @post.documents.build(document_params)

      respond_to do |format|
        if @document.save
          format.turbo_stream do
            flash.now[:notice] = "File was successfully attached"
          end
          format.html do
            flash[:notice] = "File was successfully attached"
            redirect_to cms_post_documents_path(@post)
          end
        else
          format.turbo_stream do
            render :new
          end
          format.html { render :index, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      @document = @post.documents.find(params[:id])

      respond_to do |format|
        if @document.destroy
          format.turbo_stream do
            flash.now[:notice] = "Attachment was successfully removed"
          end
          format.html do
            flash[:notice] = "Attachment was successfully removed"
            redirect_to cms_post_documents_path, status: :see_other
          end
        end
      end
    end

    private

    def set_post
      @post = Post.find(params[:post_id])
    end

    def document_params
      params.require(:document).permit(:annotation, :file)
    end
  end
end
