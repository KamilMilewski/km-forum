require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @topic = topics(:first)
    @post = posts(:first)
    @user = users(:user)
  end

  test 'valid post should be valid' do
    assert @post.valid?, 'Example fixture post should pass validation.'
  end

  test 'should update topic last_activity upon post create and update' do
    # Move last_activity back in time without issuing any validatins or
    # callbacks
    @topic.update_column(:last_activity, @topic.last_activity - 5.minutes)
    # Post create.
    last_activity = @topic.reload.last_activity
    post = @topic.posts.create(content: 'some content', user_id: @user.id)
    assert_not_equal @topic.reload.last_activity, last_activity,
                     'Creating new post should update last_activity column in' \
                     'topic'
    # Post edit.
    @topic.update_column(:last_activity, @topic.last_activity - 5.minutes)
    last_activity = @topic.reload.last_activity
    post.update(content: 'changed content')
    assert_not_equal @topic.reload.last_activity, last_activity,
                     'Updating post should update last_activity column in topic'
  end

  test 'upvotes_count should return all post upvotes count' do
    # First fixture post has sum of +2 upvotes.
    assert_equal 2, @post.upvotes_count
  end

  test 'downvotes_count should return all post downvotes count' do
    # First fixture post has sum of -1 downvotes. Function has to return
    # unsigned int though.
    assert_equal 1, @post.downvotes_count
  end

  test 'resultant_votes_count should return resultant votes' do
    # If upvotes count is 2 and downvotes count is -1, then
    # resultant_votes_count should return 1.
    assert_equal 1, @post.resultant_votes_count
  end
end
