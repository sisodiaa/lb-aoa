module TMS
  class TenderDocumentsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_tender

    def index
      @documents = @tender.documents.with_attached_file.reject(&:new_record?)
    end

    def new
      @document = @tender.documents.new
    end

    def create
      authorize @tender, policy_class: TMS::TenderDocumentPolicy

      @document = @tender.documents.build(document_params)

      respond_to do |format|
        if @document.save
          format.turbo_stream do
            @new_document = @tender.documents.new
            flash.now[:notice] = "File was successfully attached"
          end

          format.html do
            flash[:notice] = "File was successfully attached"
            redirect_to tms_tender_documents_path(@tender)
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
      authorize @tender, policy_class: TMS::TenderDocumentPolicy

      @document = @tender.documents.find(params[:id])

      respond_to do |format|
        if @document.destroy
          format.turbo_stream do
            flash.now[:notice] = "Attachment was successfully removed"
          end

          format.html do
            flash[:notice] = "Attachment was successfully removed"
            redirect_to tms_tender_documents_path(@tender), status: :see_other
          end
        end
      end
    end

    def pundit_user
      current_admin
    end

    private

    def set_tender
      @tender = Tender.find(params[:tender_id])
    end

    def document_params
      params.require(:document).permit(:annotation, :file)
    end
  end
end
