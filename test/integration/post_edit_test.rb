require 'test_helper'

class PostEditTest < ActionDispatch::IntegrationTest
  def setup
    # Admins can edit all posts. Moderators can edit all posts excluded
    # admin's posts. Users can edit only their own posts.
    @admin = users(:admin)
    @moderator = users(:moderator)
    @user = users(:user)
    @accepted_users = [@admin, @moderator, @user]

    # A villain(regular user) who will try to perform action forbidden to him.
    @villain = users(:user_4)

    # Topic in which @post is created.
    @topic = topics(:first)
    # Post created by @user.
    @post = posts(:third)
    # Post created by admin.
    @admins_post = posts(:first)

    # New valid value for post content.
    @new_content = 'New valid post content'
  end

  test 'should NOT allow moderator enter admin\'s post edit page' do
    log_in_as(@moderator)

    get edit_post_path(@admins_post)
    assert_access_denied_notice
  end

  test 'should allow admin, mod. and post owner enter post edit page' do
    @accepted_users.each do |user|
      log_in_as(user)

      get edit_post_path(@post)
      assert_template 'posts/edit'
      assert_flash_notices
    end
  end

  test 'should NOT allow user enter foreign post edit page' do
    log_in_as(@villain)

    get edit_post_path(@post)
    assert_access_denied_notice
  end

  test 'should NOT allow not logged in user enter post edit page' do
    get edit_post_path(@post)
    assert_friendly_forwarding_notice
  end

  test 'should allow admin, moderator and post owner update post' do
    @accepted_users.each do |user|
      log_in_as(user)

      patch post_path(@post), params: {
        post: {
          content: @new_content
        }
      }

      # Assert post has been updated.
      @post.reload
      assert_equal @new_content, @post.content

      assert_redirected_to @post.full_path
      follow_redirect!
      assert_flash_notices success: { count: 1 }
    end
  end

  test 'should NOT allow to update post with invalid data' do
    # Invalid data for post.
    @new_content = ''

    @accepted_users.each do |user|
      log_in_as(user)

      patch post_path(@post), params: {
        post: {
          content: @new_content
        }
      }

      # Assert post has NOT been updated.
      @post.reload
      assert_not_equal @new_content, @post.content

      assert_template 'posts/edit'
      # Check if there are form fileds with errors.
      assert_select 'div.field_with_errors'
      assert_flash_notices danger: { count: 1 }
    end
  end

  test 'should NOT allow moderator edit admin\'s post' do
    log_in_as(@moderator)

    patch post_path(@admins_post), params: {
      post: {
        content: @new_content
      }
    }

    @admins_post.reload
    assert_not_equal @new_content, @admins_post.content

    assert_access_denied_notice
  end

  test 'should NOT allow user edit foreign post' do
    log_in_as(@villain)

    # @post dosen't belong to @villain
    patch post_path(@post), params: {
      post: {
        content: @new_content
      }
    }

    # Assert post has NOT been updated.
    @post.reload
    assert_not_equal @new_content, @post.content

    assert_access_denied_notice
  end

  test 'should NOT allow not logged in user update topic' do
    patch post_path(@post), params: {
      post: {
        content: @new_content
      }
    }

    # Assert post has NOT been updated.
    @post.reload
    assert_not_equal @new_content, @post.content

    assert_access_denied_notice
  end
end
