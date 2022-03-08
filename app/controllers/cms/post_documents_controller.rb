module CMS
  class PostDocumentsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_post

    def index
    end

    def new
      @document = @post.documents.new
    end

    def create
      authorize @post, policy_class: CMS::PostDocumentsPolicy

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
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize @post, policy_class: CMS::PostDocumentsPolicy

      @document = @post.documents.find(params[:id])

      respond_to do |format|
        if @document.destroy
          format.turbo_stream do
            flash.now[:notice] = "Attachment was successfully removed"
          end
          format.html do
            flash[:notice] = "Attachment was successfully removed"
            redirect_to cms_post_documents_path(@post), status: :see_other
          end
        end
      end
    end

    def pundit_user
      current_admin
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
