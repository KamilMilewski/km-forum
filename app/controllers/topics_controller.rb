class TopicsController < ApplicationController
  before_action :find_topic, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @topic = Topics.new
  end

  def create
    @topic = Topics.new(topic_params)
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
      redirect_to topics_path
  end

  private
    def find_topic
      @topic = Topics.find(params[:id])
    end

    def topic_params
      params.require(:topic).permit(:title, :content, :category_id)
    end
end
