class TopicsController < ApplicationController
  before_action :find_topic, only: [:show, :edit, :update, :destroy]

  def show
    @posts = @topic.posts
  end

  def new
    @category = Category.find(params[:category_id])
    @topic = Topic.new
  end

  def create
    @category = Category.find(params[:category_id])
    @topic = @category.topics.new(topic_params)
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
    if @topic.destroy
      flash[:success] = 'Topic successfully deleted.'
      redirect_to @topic.category
    end
  end

  private
    def topic_params
      params.require(:topic).permit(:title, :content, :user_id)
    end

    def find_topic
      @topic = Topic.find(params[:id])
    end
end
