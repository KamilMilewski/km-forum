# :nodoc:
class PostVotesController < ApplicationController
  def create
    @post = Post.find(params[:post_id])

    if PostVote.create(post_id: params[:post_id],
                       user_id: current_user.id,
                       value: params[:value].to_i)
      # something
    end

    respond_to do |format|
      format.js
    end
  end

  def update
    @vote = PostVote.find(params[:id])
    @post = Post.find(@vote.post_id)
    @vote.value *= -1
    @vote.save

    respond_to do |format|
      format.js
    end
  end

  def destroy
    @vote = PostVote.find(params[:id])
    @post = Post.find(@vote.post_id)
    @vote.destroy

    respond_to do |format|
      format.js
    end
  end
end
