class PostsController < ApplicationController
  before_action :find_post, only: [:show, :edit, :update, :destroy]

  def new
    @post = Post.new
    @topic = Topic.find(params[:topic_id])
  end

  def create
    @topic = Topic.find(params[:topic_id])

    #We dont yet implemented User resource so we will use the one created earlier
    #in the console
    @post = @topic.posts.new(post_params.merge! user_id: User.all.first.id)
    if @post.save
      flash[:notice] = "Post successfully created."
      redirect_to @topic
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      flash[:notice] = "Post successfully updated."
      redirect_to @post.topic
    else
      render 'edit'
    end
  end

  def destroy
    if @post.destroy
      flash[:notice] = "Post successfully deleted."
      redirect_to @post.topic
    end
  end

  private
    def find_post
      @post = Post.find(params[:id])
    end

    def post_params
      params.require(:post).permit(:content, :user_id)
    end
end
