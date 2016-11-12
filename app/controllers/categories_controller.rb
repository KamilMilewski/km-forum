# :nodoc:
class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_not_logged_in, only: [:destroy]
  before_action :redirect_if_not_an_admin, only: [:destroy]

  def index
    @categories = Category.all
  end

  def show
    @topics = @category.topics.order('updated_at DESC')
                       .paginate(page: params[:page], per_page: 10)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = 'Category successfully created.'
      redirect_to @category
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:success] = 'Category successfully updated.'
      redirect_to categories_path
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    flash[:success] = 'Category successfully deleted.'
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:title, :description)
  end

  def find_category
    @category = Category.find(params[:id])
  end

  def redirect_if_not_logged_in
    redirect_to root_path unless logged_in?
  end

  def redirect_if_not_an_admin
    redirect_to root_path unless current_user.admin?
  end
end
