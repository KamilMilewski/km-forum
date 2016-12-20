# :nodoc:
class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :find_topic, only: [:new, :create]
  before_action :friendly_forwarding, only: [:new, :edit]
  before_action :redirect_if_not_logged_in, only: [:create, :update, :destroy]
  before_action :redirect_if_not_an_admin, only: [:edit, :update, :destroy]
  before_action :redirect_if_insufficient_permissions, only: [:edit,
                                                              :update,
                                                              :destroy]

  def new
    @post = Post.new
  end

  def create
    @post = @topic.posts.new(post_params)
    # User whos created post must be the current user so:
    @post.user_id = current_user.id
    if @post.save
      flash[:success] = 'Post successfully created.'
      redirect_to @post.full_path
    else
      render 'new'
    end
  end

  def edit; end

  def update
    if @post.update(post_params)
      flash[:success] = 'Post successfully updated.'
      redirect_to @post.full_path
    else
      render 'edit'
    end

    # Delete associated picture.
    @post.remove_picture! if params[:delete_picture]
  end

  def destroy
    @post.destroy
    flash[:success] = 'Post successfully deleted.'
    redirect_to @post.topic
  end

  private

  def post_params
    params.require(:post).permit(:content, :picture)
  end

  def find_post
    @post = Post.find(params[:id])
  end

  def find_topic
    @topic = Topic.find(params[:topic_id])
  end

  def redirect_if_insufficient_permissions
    return if @post.user_id == current_user.id ||
              current_user.admin? ||
              current_user.moderator?
    flash[:danger] = 'Access denied.'
    redirect_to root_path
  end

  # If someone is trying to access admin's post and himself is
  # not an admin (!current_user.admin?), he should be redirected.
  def redirect_if_not_an_admin
    return unless @post.user.admin? && !current_user.admin?
    flash[:danger] = 'Access denied.'
    redirect_to root_path
  end
end
