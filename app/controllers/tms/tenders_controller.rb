module TMS
  class TendersController < ApplicationController
    before_action :authenticate_admin!

    def show
      @tender = Tender.find(params[:id])
    end

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

    private

    def tender_params
      params.require(:tender).permit(:reference_token, :title, :description,
        :opens_on, :closes_on)
    end
  end
end
