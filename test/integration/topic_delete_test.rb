require 'test_helper'

class TopicDeleteTest < ActionDispatch::IntegrationTest
  def setup
    # Only admin should be able to delete category.
    @admin = users(:admin)
    @moderator = users(:moderator)
    @user = users(:user)
    @accepted_users = [@admin, @moderator, @user]

    # A villain(regular user) who will try to perform action forbidden to him.
    @villain = users(:user_4)

    @category = categories(:first)
    # @topic belongs to @category and is created by @user.
    @topic = topics(:third)

    # @admins_topic belongs to @category and is created by @admin.
    @admins_topic = topics(:first)
  end

  test 'should allow admin delete topic' do
    delete_topic_helper(@admin)
  end

  test 'should allow moderator delete topic' do
    delete_topic_helper(@moderator)
  end

  test 'should allow user delete his own topic' do
    delete_topic_helper(@user)
  end

  # Helper method applicable to successfull topic delete tests.
  def delete_topic_helper(user)
    log_in_as(user)
    assert_redirected_to root_path
    follow_redirect!

    # Assert exactly one topic has been deleted.
    assert_difference 'Topic.count', -1 do
      delete topic_path(@topic)
    end

    assert_redirected_to category_path(@category)
    follow_redirect!
    assert_flash_notices success: { count: 1 }
  end

  test 'should NOT allow moderator delete admin topic' do
    log_in_as(@moderator)
    assert_redirected_to root_path
    follow_redirect!

    # Assert no topics has been deleted.
    assert_no_difference 'Topic.count' do
      delete topic_path(@admins_topic)
    end

    assert_access_denied_notice
  end

  test 'should NOT allow user delete foreign topic' do
    log_in_as(@villain)
    assert_redirected_to root_path
    follow_redirect!

    # Assert no topics has been deleted.
    assert_no_difference 'Topic.count' do
      delete topic_path(@topic)
    end

    assert_access_denied_notice
  end

  test 'should NOT allow not logged in user delete topic' do
    # Assert no topics has been deleted.
    assert_no_difference 'Topic.count' do
      delete topic_path(@topic)
    end

    assert_access_denied_notice
  end
end
