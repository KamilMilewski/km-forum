# :nodoc:
class TopicsController < ApplicationController
  before_action :find_topic, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_not_logged_in, only: [:new,
                                                   :create,
                                                   :edit,
                                                   :update,
                                                   :destroy]

  def show
    @posts = @topic.posts.paginate(page: params[:page], per_page: 10)
  end

  def new
    @category = Category.find(params[:category_id])
    @topic = Topic.new
  end

  def create
    @category = Category.find(params[:category_id])
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
    return unless @topic.destroy
    flash[:success] = 'Topic successfully deleted.'
    redirect_to @topic.category
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :content, :user_id)
  end

  def redirect_if_not_logged_in
    return if logged_in?
    # Store for desired url for friendly forwarding.
    store_intended_url
    flash[:danger] = 'You must be logged in.'
    redirect_to login_path
  end

  def find_topic
    @topic = Topic.find(params[:id])
  end
end
