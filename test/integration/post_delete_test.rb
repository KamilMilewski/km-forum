require 'test_helper'

class PostDeleteTest < ActionDispatch::IntegrationTest
  def setup
    # Admins can delete all posts. Moderators can delete all posts excluded
    # admin's posts. Users can delete only their own posts.
    @admin = users(:admin)
    @moderator = users(:moderator)
    @user = users(:user)

    # A villain(regular user) who will try to perform action forbidden to him.
    @villain = users(:user_4)

    @topic = topics(:first)
    # @post belongs to @topic and is created by @user.
    @post = posts(:third)

    # @admins_post belongs to @topic and is created by @admin.
    @admins_post = posts(:first)
  end

  test 'should allow admin delete post' do
    delete_post_by(@admin)
  end

  test 'should allow moderator delete post' do
    delete_post_by(@moderator)
  end

  test 'should allow user delete his own post' do
    delete_post_by(@user)
  end

  # Helper method applicable to successfull post delete tests.
  def delete_post_by(user)
    log_in_as(user)
    assert_redirected_to root_path
    follow_redirect!

    # Assert exactly one post has been deleted.
    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end

    assert_redirected_to topic_path(@topic)
    follow_redirect!
    assert_flash_notices success: { count: 1 }
  end

  test 'should NOT allow moderator delete admin\' post' do
    log_in_as(@moderator)
    assert_redirected_to root_path
    follow_redirect!

    # Assert no post has been deleted.
    assert_no_difference 'Post.count' do
      delete post_path(@admins_post)
    end

    assert_access_denied_notice
  end

  test 'should NOT allow user delete foreign post' do
    log_in_as(@villain)
    assert_redirected_to root_path
    follow_redirect!

    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end

    assert_access_denied_notice
  end

  test 'should NOT allow not logged in user delete post' do
    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end

    assert_access_denied_notice
  end
end
