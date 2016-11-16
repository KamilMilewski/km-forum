# :nodoc:
class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :find_topic, only: [:new, :create]
  before_action :friendly_forwarding, only: [:new, :edit]
  before_action :redirect_if_not_logged_in, only: [:create, :update, :destroy]
  before_action :redirect_if_not_owner_or_admin, only: [:destroy]

  def new
    @post = Post.new
  end

  def create
    @post = @topic.posts.new(post_params)
    # User whos created post must be the current user so:
    @post.user_id = current_user.id
    if @post.save
      flash[:success] = 'Post successfully created.'
      redirect_to @topic
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:success] = 'Post successfully updated.'
      redirect_to @post.topic
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = 'Post successfully deleted.'
    redirect_to @post.topic
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def find_topic
    @topic = Topic.find(params[:topic_id])
  end

  def friendly_forwarding
    return if logged_in?
    # Store for desired url for friendly forwarding.
    store_intended_url
    flash[:danger] = 'You must be logged in.'
    redirect_to
  end

  def redirect_if_not_logged_in
    return if logged_in?
    flash[:danger] = 'Access denied'
    redirect_to root_path
  end

  def redirect_if_not_owner_or_admin
    return if @post.user_id == current_user.id || current_user.admin?
    flash[:danger] = 'Access denied.'
    redirect_to root_path
  end
end
