require 'test_helper'

class PostCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
    @post = posts(:first)
    @topic = topics(:first)
  end

  test 'valid post creation' do
    log_in_as(@user)
    # Get to new category page and assure that correct template is used.
    get new_topic_post_path @topic
    assert_response :success
    assert_template 'posts/new'
    # Test if create category with valid data vill succeed.
    assert_difference 'Post.count', 1 do
      post topic_posts_path(@post), params: { post: {
        content: 'test description'
      } }
    end
    assert_response :redirect
    follow_redirect!
    assert_template 'topics/show'
    # Check if success flash massage shows up.
    assert_flash_notices success: { count: 1 }
  end

  test 'invalid post creation' do
    log_in_as(@user)
    # Get to new category page and assure that correct template is used.
    get new_topic_post_path @topic
    assert_response :success
    assert_template 'posts/new'
    # Test if create category with valid data will fail.
    assert_no_difference 'Post.count' do
      post topic_posts_path(@post), params: { post: {
        content: "\t",
        user_id: @user.id
      } }
    end
    assert_template 'posts/new'
    assert_flash_notices danger: { count: 1 }
  end

  test 'trying to create a post as another user' do
    log_in_as(@user)
    # id of the user we want maliciously impersonate during post creation.
    target_user_id = 6
    get new_topic_post_path @topic
    post topic_posts_path(@post), params: { post: {
      content: 'some content',
      user_id: target_user_id
    } }
    post = assigns(:post)
    # Assert that newly created post belongs to logged in user.
    assert_equal post.user_id, @user.id
  end
end
