module TMS
  class TendersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_tender, only: [:show, :edit, :update]

    def index
      @status = params[:status]
      @pagy, @tenders = pagy(tender_list, items: 5)
    end

    def show; end

    def new
      @tender = Tender.new
    end

    def create
      @tender = Tender.new(tender_params)

      if @tender.save
        redirect_to tms_tender_path(@tender), notice: "Tender was successfully created."
      else
        respond_to do |format|
          format.turbo_stream do
            render :new
          end
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def edit; end

    def update
      if @tender.update(tender_params)
        redirect_to tms_tender_path(@tender), notice: "Tender was successfully updated."
      else
        respond_to do |format|
          format.turbo_stream do
            render :edit
          end
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    private

    def tender_list
      return Tender.draft.order(created_at: :asc) if params[:status] == "draft"
      Tender.published.try!(params[:status].to_sym)
    rescue NoMethodError
      Tender.all
    end

    def set_tender
      @tender = Tender.find(params[:id])
    end

    def tender_params
      params.require(:tender).permit(:reference_token, :title, :description,
        :opens_on, :closes_on)
    end
  end
end
