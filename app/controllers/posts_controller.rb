class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_not_logged_in, only: [:new,
                                                   :create,
                                                   :edit,
                                                   :update,
                                                   :destroy]
  def new
    @post = Post.new
    @topic = Topic.find(params[:topic_id])
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.new(post_params)
    # User whos created post must be the current user so:
    @post.user_id = find_current_user.id
    if @post.save
      flash[:success] = "Post successfully created."
      redirect_to @topic
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:success] = "Post successfully updated."
      redirect_to @post.topic
    else
      render 'edit'
    end
  end

  def destroy
    if @post.destroy
      flash[:success] = "Post successfully deleted."
      redirect_to @post.topic
    end
  end

  private
    def find_post
      @post = Post.find(params[:id])
    end

    def redirect_if_not_logged_in
      unless logged_in?
        # Store for desired url for friendly forwarding.
        store_intended_url
        flash[:danger] = 'You must be logged in.'
        redirect_to login_path
      end
    end

    def post_params
      params.require(:post).permit(:content)
    end
end
