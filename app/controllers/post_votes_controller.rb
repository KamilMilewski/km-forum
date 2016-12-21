class PostVotesController < ApplicationController
  def create
    return unless @post = Post.find(params[:post_id])
    @value = params[:value]

    @existing_vote = PostVote.find_by(user_id: current_user.id, post_id: @post.id)

    # if @existing_vote = PostVote.find_by(user_id: current_user.id, post_id: @post.id)
    #   #debugger
    #   @existing_vote.destroy
    # end

    if !@existing_vote.nil? && @existing_vote.vote == 1 && @value == 'up'
      # User clicked again on upvote. That means he wants to cancel his vote.
      @existing_vote.destroy
    elsif !@existing_vote.nil? && @existing_vote.vote == 1 && @value == 'down'
      # User clicked downvote but he clicked upvote before. We need to
      # cancel previous vote and make new one.
      @existing_vote.destroy
      @vote = @post.post_votes.create(user_id: current_user.id, vote: -1)
    elsif !@existing_vote.nil? && @existing_vote.vote == -1 && @value == 'down'
      # User clicked again on downvote. That means he wants to cancel his vote.
      @existing_vote.destroy
    elsif !@existing_vote.nil? && @existing_vote.vote == -1 && @value == 'up'
      # User clicked upvote but he clicked downvote before. We need to
      # cancel previous vote and make new one.
      @existing_vote.destroy
      @vote = @post.post_votes.create(user_id: current_user.id, vote: 1)
    elsif @value == 'up'
      # User clicked upvote.
      @vote = @post.post_votes.create(user_id: current_user.id, vote: 1)
    elsif @value == 'down'
      # User clicked downvote.
      @vote = @post.post_votes.create(user_id: current_user.id, vote: -1)
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy; end
end
