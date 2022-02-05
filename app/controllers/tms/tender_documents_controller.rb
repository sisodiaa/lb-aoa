module TMS
  class TenderDocumentsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_tender

    def index
      @document = @tender.documents.new
    end

    def create
      @document = @tender.documents.build(document_params)

      respond_to do |format|
        if @document.save
          format.turbo_stream do
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

    private

    def set_tender
      @tender = Tender.find(params[:tender_id])
    end

    def document_params
      params.require(:document).permit(:annotation, :file)
    end
  end
end
