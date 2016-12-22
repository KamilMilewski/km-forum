require 'test_helper'

class PostVoteTest < ActiveSupport::TestCase
  def setup
    # valid vote
    @vote = post_votes(:first)
  end

  test 'valid vote should be valid' do
    assert @vote.valid?, 'Example fixture post vote should pass validation'
  end

  test 'vote can be either +1 or -1' do
    @vote.value = -5
    assert_not @vote.valid?
  end

  test 'vote can NOT be nil' do
    @vote.value = nil
    assert_not @vote.valid?
  end

  test 'user_id post_id pair should be unique' do
    # Duplicated vote
    @duplicated_vote = PostVote.new(user_id: @vote.user_id,
                                    post_id: @vote.post_id,
                                    value: @vote.value)

    # Try to save duplicated post vote.
    assert_no_difference 'PostVote.count' do
      @duplicated_vote.save
    end
  end
end
