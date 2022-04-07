module TMS
  class TendersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_tender, only: [:show, :edit, :update, :destroy]

    def index
      @status = params[:status]
      @pagy, @tenders = pagy(tender_list, items: 5)

      respond_to do |format|
        format.turbo_stream
        format.html
      end
    end

    def show; end

    def new
      @tender = Tender.new
    end

    def create
      @tender = Tender.new(tender_params)

      respond_to do |format|
        if @tender.save
          format.turbo_stream { flash.now[:success] = "Tender was successfully created." }

          format.html do
            flash[:success] = "Tender was successfully created."
            redirect_to tms_tender_path(@tender)
          end
        else
          format.turbo_stream { render :new }
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def edit
      authorize @tender, policy_class: TMS::TenderPolicy
    end

    def update
      authorize @tender, policy_class: TMS::TenderPolicy

      respond_to do |format|
        if @tender.update(tender_params)
          format.turbo_stream { flash.now[:success] = "Tender was successfully updated." }

          format.html do
            flash[:success] = "Tender was successfully updated."
            redirect_to tms_tender_path(@tender)
          end
        else
          format.turbo_stream { render :edit }
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      authorize @tender, policy_class: TMS::TenderPolicy

      respond_to do |format|
        if @tender.destroy
          format.turbo_stream do
            flash.now[:notice] = "Tender was successfully destroyed."
          end
          format.html do
            flash[:notice] = "Tender was successfully destroyed."
            redirect_to tms_tenders_url, status: :see_other
          end
        end
      end
    end

    def pundit_user
      current_admin
    end

    private

    def tender_list
      return Tender.draft.order(created_at: :asc) if params[:status] == "draft"
      Tender.published.try!(params[:status].to_sym)
    rescue NoMethodError
      Tender.all.order(created_at: :asc)
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
