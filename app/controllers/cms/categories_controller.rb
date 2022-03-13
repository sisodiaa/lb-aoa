module CMS
  class CategoriesController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_category, only: [:show, :edit, :update]

    def index
      @categories = Category.all.order(created_at: :asc)
    end

    def show; end

    def new
      @category = Category.new
    end

    def create
      @category = Category.new(category_params)

      respond_to do |format|
        if @category.save
          format.turbo_stream do
            @categories = Category.all.order(created_at: :asc)
            flash.now[:success] = "Category was successfully created."
          end

          format.html do
            flash[:success] = "Category was successfully created."
            redirect_to cms_categories_path
          end
        else
          format.turbo_stream { render :new }
          format.html { render :new, status: :unprocessable_entity }
        end
      end
    end

    def edit; end

    def update
      respond_to do |format|
        if @category.update(category_params)
          format.turbo_stream do
            @categories = Category.all.order(created_at: :asc)
            flash.now[:success] = "Category was successfully updated."
          end

          format.html do
            flash[:success] = "Category was successfully updated."
            redirect_to cms_categories_path
          end
        else
          format.turbo_stream { render :edit }
          format.html { render :edit, status: :unprocessable_entity }
        end
      end
    end

    private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
  end
end
