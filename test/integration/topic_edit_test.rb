require 'test_helper'

class TopicEditTest < ActionDispatch::IntegrationTest
  def setup
    # Admins can edit all topics. Moderators can edit all topics excluded
    # admin's topics. Users can edit only their own topics.
    @admin = users(:admin)
    @moderator = users(:moderator)
    @user = users(:user)
    @accepted_users = [@admin, @moderator, @user]

    # A villain(regular user) who will try to perform action forbidden to him.
    @villain = users(:user_4)

    # Topic created by @user.
    @topic = topics(:third)
    # New valid values for topic title and content.
    @new_title = 'New valid topic title'
    @new_content = 'New valid topic content'
  end

  test 'should NOT allow moderator enter admin\'s topic edit page' do
    # :TODO:
  end

  test 'should NOT allow moderator edit admin\'s topic' do
    # :TODO:
  end

  test 'should allow admin, mod. and topic owner enter topic edit page' do
    # users who can visit edit page: admin, moderator and user who owns @topic
    @accepted_users.each do |user|
      log_in_as(user)
      assert_redirected_to root_path
      follow_redirect!

      get edit_topic_path(@topic)
      assert_template 'topics/edit'
      assert_flash_notices
    end
  end

  test 'should NOT allow user enter foreign topic edit page' do
    log_in_as(@villain)
    assert_redirected_to root_path
    follow_redirect!

    get edit_topic_path(@topic)
    assert_access_denied_notice
  end

  test 'should NOT allow not logged in user enter topic edit page' do
    get edit_topic_path(@topic)
    assert_friendly_forwarding_notice
  end

  test 'should allow admin, moderator and topic owner update topic' do
    @accepted_users.each do |user|
      log_in_as(user)
      assert_redirected_to root_path
      follow_redirect!

      patch topic_path(@topic), params: {
        topic: {
          title: @new_title,
          content: @new_content
        }
      }

      # Assert topic has been updated.
      @topic.reload
      assert_equal @new_title, @topic.title
      assert_equal @new_content, @topic.content

      assert_redirected_to topic_path(@topic)
      follow_redirect!
      assert_flash_notices success: { count: 1 }
    end
  end

  test 'should NOT allow to update topic with invalid data' do
    # Invalid data for topic.
    @new_title = ''
    @new_content = ''

    @accepted_users.each do |user|
      log_in_as(user)
      assert_redirected_to root_path
      follow_redirect!

      patch topic_path(@topic), params: {
        topic: {
          title: @new_title,
          content: @new_content
        }
      }

      # Assert topic has NOT been updated.
      @topic.reload
      assert_not_equal @new_title, @topic.title
      assert_not_equal @new_content, @topic.content

      assert_template 'topics/edit'
      assert_flash_notices danger: { count: 1 }
    end
  end

  test 'should NOT allow user edit foreign topic' do
    log_in_as(@villain)
    assert_redirected_to root_path
    follow_redirect!

    # @topic dosen't belong to @villain
    patch topic_path(@topic), params: {
      topic: {
        title: @new_title,
        content: @new_content
      }
    }

    # Assert topic has NOT been updated.
    @topic.reload
    assert_not_equal @new_title, @topic.title
    assert_not_equal @new_content, @topic.content

    assert_access_denied_notice
  end

  test 'should NOT allow not logged in user update topic' do
    patch topic_path(@topic), params: {
      topic: {
        title: @new_title,
        content: @new_content
      }
    }

    # Assert topic has NOT been updated.
    @topic.reload
    assert_not_equal @new_title, @topic.title
    assert_not_equal @new_content, @topic.content

    assert_access_denied_notice
  end
end
