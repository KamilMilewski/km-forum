require 'test_helper'

class TopicVotesTest < ActionDispatch::IntegrationTest
  def setup
    # This user will vote like creazy.
    @user = users(:user)

    # Topic without any votes.
    @topic = topics(:third)
  end

  test 'user votes on topic like creazy' do
    log_in_as(@user)
    get topic_path(@topic)
    # @user hasn't voted on this topic before. There should be 2 links to
    # topic_votes#create present: upvote and downvote.
    assert_no_vote_links_for(@topic)

    #
    # Lets upvote(Like)
    #
    assert_difference 'TopicVote.count', 1 do
      post topic_votes_path, params: { resource_id: @topic.id, value: 1 },
                             xhr: true
    end
    # Store last vote in convenient variable for a while.
    @vote = @topic.topic_votes.first
    # Now that user has voted there should be one link to topic_votes#destroy
    # (unlike) and one to topic_votes#edit (change vote from upvote to downvote)
    assert_voted_links_for(@topic)

    #
    # Lets cancel previous upvote(unlike)
    #
    assert_difference 'TopicVote.count', -1 do
      delete topic_vote_path(@vote), xhr: true
    end
    # Again looks like @user hasn't voted on this topic before. There should be
    # 2 links to topic_votes#create present: upvote and downvote.
    assert_no_vote_links_for(@topic)

    #
    # Lets downvote
    #
    assert_difference 'TopicVote.count', 1 do
      post topic_votes_path, params: { resource_id: @topic.id, value: -1 },
                             xhr: true
    end
    # Store last vote in convenient variable for a while.
    @vote = @topic.topic_votes.first
    # Now that user has voted there should be one link to topic_votes#destroy
    # (unlike) and one to topic_votes#edit (change vote from upvote to downvote)
    assert_voted_links_for(@topic)

    #
    # Lets cancel last downvote
    #
    assert_difference 'TopicVote.count', -1 do
      delete topic_vote_path(@vote), xhr: true
    end
    # Again looks like @user hasn't voted on this topic before. There should be
    # 2 links to topic_votes#create present: upvote and downvote.
    assert_no_vote_links_for(@topic)

    #
    # Lets upvote and then right after downvote
    #
    assert_difference 'TopicVote.count', 1 do
      post topic_votes_path, params: { resource_id: @topic.id, value: 1 },
                             xhr: true
    end
    # Store last vote in convenient variable for a while.
    @vote = @topic.topic_votes.first
    # Now lets click on downvote. It will issue update action in controller.
    # It should edit existing @vote.
    assert_no_difference 'TopicVote.count' do
      put topic_vote_path(@vote), xhr: true
    end
    assert_voted_links_for(@topic)
    # Now lets check if vote changed value.
    assert_equal(-1, @vote.reload.value)

    #
    # We downvoted last time. Now lets upvote right away.
    #
    assert_no_difference 'TopicVote.count' do
      put topic_vote_path(@vote), xhr: true
    end
    assert_voted_links_for(@topic)
    assert_equal(1, @vote.reload.value)
  end

  # Helpers only for this topic votes tests.
  def assert_no_vote_links_for(topic)
    get topic_path(topic)
    assert_select 'a[href=?]',
                  topic_votes_path(resource_id: topic.id, value: 1), count: 1
    assert_select 'a[href=?]',
                  topic_votes_path(resource_id: topic.id, value: -1), count: 1
  end

  def assert_voted_links_for(topic)
    get topic_path(topic)
    assert_select 'a[href=?][data-method=delete]', topic_vote_path(@vote),
                  count: 1
    assert_select 'a[href=?][data-method=put]', topic_vote_path(@vote),
                  count: 1
  end
end
