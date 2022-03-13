module CMS
  class CategoriesController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_category, only: [:edit, :update]

    def index; end
    def new; end

    def create
      @category = Category.new(category_params)

      if @category.save
        flash[:success] = "Category was successfully created."
        redirect_to cms_categories_path
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @category.update(category_params)
        flash[:success] = "Category was successfully updated."
        redirect_to cms_categories_path
      else
        render :edit, status: :unprocessable_entity
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
