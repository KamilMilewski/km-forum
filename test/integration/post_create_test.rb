require 'test_helper'

class PostCreateTest < ActionDispatch::IntegrationTest
  def setup
    # Every logged in user can create post.
    @admin = users(:admin)
    @moderator = users(:moderator)
    @user = users(:user)
    @accepted_users = [@admin, @moderator, @user]

    # A villain(regular user) who will try to perform action forbidden to him.
    @villain = users(:user_4)

    # Post will be created in @topic.
    @topic = topics(:first)

    @post = posts(:first)
  end

  test 'should allow logged in user enter new post page' do
    @accepted_users.each do |user|
      log_in_as(user)

      get new_topic_post_path(@topic)

      assert_template 'posts/new'
      assert_flash_notices
    end
  end

  test 'should NOT allow not logged in user enter new post page' do
    get new_topic_post_path(@topic)

    assert_friendly_forwarding_notice
  end

  test 'should allow logged in user create post' do
    @accepted_users.each do |user|
      log_in_as(user)

      # Assure new post has been created.
      assert_difference 'Post.count', 1 do
        post topic_posts_path(@topic), params: {
          post: {
            content: 'Valid post content'
          }
        }
      end

      assert_redirected_to topic_path(@topic)
      follow_redirect!
      assert_flash_notices success: { count: 1 }
    end
  end

  test 'should NOT allow create post with invalid data' do
    log_in_as(@user)

    # Assure no post has been created - using invalid data.
    assert_no_difference 'Post.count' do
      post topic_posts_path(@topic), params: {
        post: {
          content: ''
        }
      }
    end

    assert_template 'posts/new'
    # Check if there are form fileds with errors.
    assert_select 'div.field_with_errors'
    assert_flash_notices danger: { count: 1 }
  end

  test 'should NOT allow not logged in user create post' do
    # Assure no post has been created.
    assert_no_difference 'Post.count' do
      post topic_posts_path(@topic), params: {
        post: {
          content: 'Valid post content'
        }
      }
    end

    assert_access_denied_notice
  end

  test 'should NOT allow user disguise as another user during post creation' do
    log_in_as(@villain)

    # @villain is trying to disguise himself as another user by appending
    # user_id = target_user_id to POST parameters.
    post topic_posts_path(@topic), params: {
      post: {
        content: 'Valid post content',
        user_id: @user.id
      }
    }

    # :FIXME assigns should not be used in but I don't have better idea.
    # Assert that newly created post belongs to currently logged in user.
    assert_equal assigns(:post).user_id, @villain.id
  end
end
