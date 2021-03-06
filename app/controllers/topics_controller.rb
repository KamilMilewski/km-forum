# :nodoc:
class TopicsController < ApplicationController
  before_action :find_topic, only: [:show, :edit, :update, :destroy]
  before_action :find_category, only: [:new, :create]
  before_action :friendly_forwarding, only: [:new, :edit]
  before_action :redirect_if_not_logged_in, only: [:create, :update, :destroy]
  before_action :redirect_if_not_an_admin, only: [:edit, :update, :destroy]
  before_action :redirect_if_insufficient_permissions, only: [:edit,
                                                              :update,
                                                              :destroy]

  def show
    @posts = @topic.posts.paginate(page: params[:page],
                                   per_page: KmForum::POSTS_PER_PAGE)
    render 'posts/index'
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

  def edit; end

  def update
    if @topic.update(topic_params)
      flash[:success] = 'Topic successfully updated.'
      redirect_to @topic
    else
      render 'edit'
    end

    # Delete associated picture.
    @topic.remove_picture! if params[:delete_picture]
  end

  def destroy
    @topic.destroy
    flash[:success] = 'Topic successfully deleted.'
    redirect_to @topic.category
  end

  private

  def topic_params
    params.require(:topic).permit(:title, :content, :picture, :user_id)
  end

  def find_topic
    @topic = Topic.find(params[:id])
  end

  def find_category
    @category = Category.find(params[:category_id])
  end

  # If someone is trying to access admin's topic edit and himself is
  # not an admin (!current_user.admin?), he should be redirected.
  def redirect_if_not_an_admin
    return unless @topic.user.admin? && !current_user.admin?
    flash[:danger] = 'Access denied.'
    redirect_to root_path
  end

  def redirect_if_insufficient_permissions
    return if @topic.user_id == current_user.id ||
              current_user.admin? ||
              current_user.moderator?
    flash[:danger] = 'Access denied.'
    redirect_to root_path
  end
end
