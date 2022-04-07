module Front
  class TenderDocumentsController < ApplicationController
    layout -> { turbo_frame_request? ? false : "front" }

    def index
      @tender = Tender.find(params[:tender_id])
      @documents = @tender.documents.with_attached_file
    end
  end
end
