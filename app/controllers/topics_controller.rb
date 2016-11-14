# :nodoc:
class TopicsController < ApplicationController
  before_action :find_topic, only: [:show, :edit, :update, :destroy]
  before_action :find_category, only: [:new, :create]
  before_action :friendly_forwarding, only: [:new, :edit]
  before_action :redirect_if_not_logged_in, only: [:create, :update, :destroy]
  before_action :redirect_if_not_owner_or_admin, only: [:destroy]

  def show
    @posts = @topic.posts.paginate(page: params[:page], per_page: 10)
  end

  def new
    @topic = Topic.new
  end

  def create
    @topic = @category.topics.new(topic_params)
    # User whos created topic must be the current user so:
    @topic.user_id = current_user.id
    if @topic.save
      flash[:success] = 'Topic successfully created.'
      redirect_to @topic
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      flash[:success] = 'Topic successfully updated.'
      redirect_to @topic
    else
      render 'edit'
    end
  end

  def destroy
    @topic.destroy
    flash[:success] = 'Topic successfully deleted.'
    redirect_to @topic.category
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :content, :user_id)
  end

  def find_topic
    @topic = Topic.find(params[:id])
  end

  def find_category
    @category = Category.find(params[:category_id])
  end

  def friendly_forwarding
    return if logged_in?
    # Store for desired url for friendly forwarding.
    store_intended_url
    flash[:danger] = 'You must be logged in.'
    redirect_to login_path
  end

  def redirect_if_not_logged_in
    flash[:danger] = 'Access denied'
    redirect_to root_path unless logged_in?
  end

  def redirect_if_not_owner_or_admin
    return if @topic.user_id == current_user.id || current_user.admin?
    flash[:danger] = 'Access denied'
    redirect_to root_path
  end
end
