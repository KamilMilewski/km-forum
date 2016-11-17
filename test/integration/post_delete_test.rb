require 'test_helper'

class PostDeleteTest < ActionDispatch::IntegrationTest
  def setup
    # Only admin should be able to delete category.
    @admin = users(:admin)
    # Just regular villain(user) who will try to perform action forbidden to him
    @villain = users(:user_4)
    @user = users(:user)
    @topic = topics(:first)
    # @post belongs to @topic, created by user
    @post = posts(:third)
  end

  test 'successful post delete from posts index page, as an admin' do
    log_in_as(@admin)
    get topic_path(@topic)

    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end

    # Aka posts index
    assert_redirected_to @topic
    follow_redirect!
    assert_flash_notices success: { count: 1 }
  end

  test 'user should be able to delete his post' do
    log_in_as(@user)
    get topic_path(@topic)

    assert_difference 'Post.count', -1 do
      delete post_path(@post)
    end

    # Aka posts index
    assert_redirected_to @topic
    follow_redirect!
    assert_flash_notices success: { count: 1 }
  end

  test 'villanous attempt to delete post by non admin user who do not own' \
       ' given post should fail' do
    # Log in as non admin user.
    log_in_as(@villain)
    get topic_path(@topic)

    assert_no_difference 'Topic.count' do
      delete post_path(@post)
    end
    assert_redirected_to root_path
  end

  test 'villanous attempt to delete post by non logged in user should' \
       'fail' do
    get topic_path(@topic)

    assert_no_difference 'Post.count' do
      delete post_path(@post)
    end
    assert_redirected_to root_path
  end
end
