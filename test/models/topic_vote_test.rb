require 'test_helper'

class TopicVoteTest < ActiveSupport::TestCase
  def setup
    # valid vote
    @vote = topic_votes(:first)
  end

  test 'valid vote should be valid' do
    assert @vote.valid?, 'Example fixture topic vote should pass validation'
  end

  test 'vote can be either +1 or -1' do
    @vote.value = -5
    assert_not @vote.valid?
  end

  test 'vote can NOT be nil' do
    @vote.value = nil
    assert_not @vote.valid?
  end

  test 'user_id topic_id pair should be unique' do
    # Duplicated vote
    @duplicated_vote = TopicVote.new(user_id: @vote.user_id,
                                     topic_id: @vote.topic_id,
                                     value: @vote.value)

    # Try to save duplicated topic vote.
    assert_no_difference 'TopicVote.count' do
      @duplicated_vote.save
    end
  end
end
