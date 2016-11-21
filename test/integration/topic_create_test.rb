require 'test_helper'

class TopicCreateTest < ActionDispatch::IntegrationTest
  def setup
    # Every logged in user can create topic.
    @admin = users(:admin)
    @moderator = users(:moderator)
    @user = users(:user)
    @accepted_users = [@admin, @moderator, @user]

    # A villain(regular user) who will try to perform action forbidden to him.
    @villain = users(:user_4)

    # Topic will be created in @category.
    @category = categories(:first)
  end

  test 'should allow logged in user enter new topic page' do
    @accepted_users.each do |user|
      log_in_as(user)

      get new_category_topic_path(@category)

      assert_template 'topics/new'
      assert_flash_notices
    end
  end

  test 'should NOT allow not logged in user enter new topic page' do
    get new_category_topic_path(@category)

    assert_friendly_forwarding_notice
  end

  test 'should allow logged in user create topic' do
    @accepted_users.each do |user|
      log_in_as(user)

      # Assure new topic has been created.
      assert_difference 'Topic.count', 1 do
        post category_topics_path(@category), params: {
          topic: {
            title: 'Valid topic title',
            content: 'Valid topic content'
          }
        }
      end

      # :FIXME assigns should not be used in but I don't have better idea.
      assert_redirected_to topic_path(assigns(:topic))
      follow_redirect!
      assert_flash_notices success: { count: 1 }
    end
  end

  test 'should NOT allow create topic with invalid data' do
    log_in_as(@admin)

    # Assure no topic has been created - using invalid data.
    assert_no_difference 'Topic.count' do
      post category_topics_path(@category), params: {
        topic: {
          title: '',
          content: ''
        }
      }
    end

    assert_template 'topics/new'
    # Check if there are form fileds with errors.
    assert_select 'div.field_with_errors'
    assert_flash_notices danger: { count: 1 }
  end

  test 'should NOT allow not logged in user create topic' do
    # Assure no topic has been created.
    assert_no_difference 'Topic.count' do
      post category_topics_path(@category), params: {
        topic: {
          title: 'Valid topic title',
          content: 'Valid topic content'
        }
      }
    end

    assert_access_denied_notice
  end

  test 'should NOT allow user disguise as another user during topic creation' do
    log_in_as(@villain)

    # @villain is trying to disguise himself as another user by appending
    # user_id = target_user_id to POST parameters.
    post category_topics_path(@category), params: {
      topic: {
        title: 'Valid topic title',
        content: 'Valid topic content',
        user_id: @user.id
      }
    }

    # :FIXME assigns should not be used in but I don't have better idea.
    # Assert that newly created topic belongs to currently logged in user.
    assert_equal assigns(:topic).user_id, @villain.id
  end
end
