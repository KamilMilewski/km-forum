require 'test_helper'

class PostVotesTest < ActionDispatch::IntegrationTest
  def setup
    # This user will vote like creazy.
    @user = users(:user)

    # Post without any votes.
    @post = posts(:third)
  end

  test 'user votes on post like creazy' do
    log_in_as(@user)
    get @post.full_path

    # @user hasn't voted on this post before. There should be 2 links to
    # post_votes#create present: upvote and downvote.
    assert_no_vote_links_for(@post)

    #
    # Lets upvote(Like)
    #
    assert_difference 'PostVote.count', 1 do
      post post_votes_path, params: { resource_id: @post.id, value: 1 },
                            xhr: true
    end
    # Store last vote in convenient variable for a while.
    @vote = @post.post_votes.first
    # Now that user has voted there should be one link to post_votes#destroy
    # (unlike) and one to post_votes#edit (change vote from upvote to downvote)
    assert_voted_links_for(@post)

    #
    # Lets cancel previous upvote(unlike)
    #
    assert_difference 'PostVote.count', -1 do
      delete post_vote_path(@vote), xhr: true
    end
    # Again looks like @user hasn't voted on this post before. There should be
    # 2 links to post_votes#create present: upvote and downvote.
    assert_no_vote_links_for(@post)

    #
    # Lets downvote
    #
    assert_difference 'PostVote.count', 1 do
      post post_votes_path, params: { resource_id: @post.id, value: -1 },
                            xhr: true
    end
    # Store last vote in convenient variable for a while.
    @vote = @post.post_votes.first
    # Now that user has voted there should be one link to post_votes#destroy
    # (unlike) and one to post_votes#edit (change vote from upvote to downvote)
    assert_voted_links_for(@post)

    #
    # Lets cancel last downvote
    #
    assert_difference 'PostVote.count', -1 do
      delete post_vote_path(@vote), xhr: true
    end
    # Again looks like @user hasn't voted on this post before. There should be
    # 2 links to post_votes#create present: upvote and downvote.
    assert_no_vote_links_for(@post)

    #
    # Lets upvote and then right after downvote
    #
    assert_difference 'PostVote.count', 1 do
      post post_votes_path, params: { resource_id: @post.id, value: 1 },
                            xhr: true
    end
    # Store last vote in convenient variable for a while.
    @vote = @post.post_votes.first
    # Now lets click on downvote. It will issue update action in controller.
    # It should edit existing @vote.
    assert_no_difference 'PostVote.count' do
      put post_vote_path(@vote), xhr: true
    end
    assert_voted_links_for(@post)
    # Now lets check if vote changed value.
    assert_equal(-1, @vote.reload.value)

    #
    # We downvoted last time. Now lets upvote right away.
    #
    assert_no_difference 'PostVote.count' do
      put post_vote_path(@vote), xhr: true
    end
    assert_voted_links_for(@post)
    assert_equal(1, @vote.reload.value)
  end

  # Helpers only for this post votes tests.
  def assert_no_vote_links_for(post)
    get post.full_path
    assert_select 'a[href=?]',
                  post_votes_path(resource_id: post.id, value: 1), count: 1
    assert_select 'a[href=?]',
                  post_votes_path(resource_id: post.id, value: -1), count: 1
  end

  def assert_voted_links_for(post)
    get post.full_path
    assert_select 'a[href=?][data-method=delete]', post_vote_path(@vote),
                  count: 1
    assert_select 'a[href=?][data-method=put]', post_vote_path(@vote),
                  count: 1
  end
end
