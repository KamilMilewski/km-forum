# Controller for post votes.
class PostVotesController < ApplicationController
  def create
    @post = Post.find(params[:resource_id])

    if PostVote.create(post_id: params[:resource_id],
                       user_id: current_user.id,
                       value: params[:value].to_i)
      # something
    end

    respond
  end

  def update
    @vote = PostVote.find(params[:id])
    @post = Post.find(@vote.post_id)
    # Updating vote always mean change form +1 to -1 or -1 to +1
    @vote.value *= -1

    if @vote.save
      # do something
    end

    respond
  end

  def destroy
    @vote = PostVote.find(params[:id])
    @post = Post.find(@vote.post_id)

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
