# Controller for topic votes.
class TopicVotesController < ApplicationController
  def create
    @topic = Topic.find(params[:resource_id])

    if TopicVote.create(topic_id: params[:resource_id],
                        user_id: current_user.id,
                        value: params[:value].to_i)
      # do something
    end

    respond
  end

  def update
    @vote = TopicVote.find(params[:id])
    @topic = Topic.find(@vote.topic_id)
    # Updating vote always mean change form +1 to -1 or -1 to +1
    @vote.value *= -1

    if @vote.save
      # do something
    end

    respond
  end

  def destroy
    @vote = TopicVote.find(params[:id])
    @topic = Topic.find(@vote.topic_id)

    if @vote.destroy
      # do something
    end

    respond
  end

  private

  def respond
    respond_to do |format|
      format.js
    end
  end
end
