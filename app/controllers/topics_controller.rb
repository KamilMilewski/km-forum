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
    #We dont yet implemented User resource so we will use the one created earlier
    #in the console
    @topic = @category.topics.new(topic_params.merge! user_id: User.all.first.id)
    if @topic.save
      flash[:notice] = 'Topic successfully created.'
      redirect_to @topic
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @topic.update(topic_params)
      flash[:notice] = 'Topic successfully updated.'
      redirect_to @topic
    else
      render 'edit'
    end
  end

  def destroy
    if @topic.destroy
      flash[:notice] = 'Topic successfully deleted.'
      redirect_to @topic.category
    end
  end

  private
    def find_topic
      @topic = Topic.find(params[:id])
    end

    def topic_params
      params.require(:topic).permit(:title, :content, :user_id)
    end
end
