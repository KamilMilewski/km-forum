class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def show

  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category successfully created."
      redirect_to categories_path
    else
      render 'new'
    end
  end

  def edit

  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Category successfully updated."
      redirect_to categories_path
    else
      render "edit"
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = "Category successfully deleted."
    redirect_to categories_path
  end

  private
    def category_params
      params.require(:category).permit(:title, :description)
    end

    def find_category
      @category = Category.find(params[:id])
    end
end
