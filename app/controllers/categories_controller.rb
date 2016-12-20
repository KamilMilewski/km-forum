# :nodoc:
class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]
  before_action :friendly_forwarding, only: [:new, :edit]
  before_action :redirect_if_not_logged_in, only: [:create, :update, :destroy]
  before_action :redirect_if_not_an_admin, only: [:new,
                                                  :create,
                                                  :edit,
                                                  :update,
                                                  :destroy]

  def index
    @categories = Category.all
  end

  def show
    @topics = @category.topics.paginate(page: params[:page],
                                        per_page: KmForum::TOPICS_PER_PAGE)
    render 'topics/index'
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

  def edit; end

  def update
    if @category.update(category_params)
      flash[:success] = 'Category successfully updated.'
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    flash[:success] = 'Category successfully deleted.'
    redirect_to root_path
  end

  private

  def category_params
    params.require(:category).permit(:title, :description)
  end

  def find_category
    @category = Category.find(params[:id])
  end

  # Should be used when logged in user don't have rights to perform given action
  def redirect_if_not_an_admin
    return if current_user.admin?
    flash[:danger] = 'Access denied.'
    redirect_to root_path
  end
end
