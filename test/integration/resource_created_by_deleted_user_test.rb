require 'test_helper'

class ResourceCreatedByDeletedUserTest < ActionDispatch::IntegrationTest
  # When user is deleted his topics and posts stay in db. There is need to check
  # how app behaves during displaying those posts and topics.
  def setup
    @user = users(:user)
    @category = categories(:first)
    @topic = @category.topics.first
  end

  test 'should visit categories index with topic belonged to deleted user' do
    @category.topics.create!(title: 'some title',
                             content: 'some content',
                             user_id: @user.id,
                             last_activity: Time.zone.now + 1.hour)
    @category.last_topic.user.destroy!
    get root_path
    assert_response :success
  end

  test 'should visit categories index with post belonged to deleted user' do
    @topic.posts.create!(content: 'some content', user_id: @user.id)
    @category.last_post.user.destroy!
    get root_path
    assert_response :success
  end

  test 'should visit topics index with topic belonged to deleted user' do
    @category.topics.create!(title: 'some title',
                             content: 'some content',
                             user_id: @user.id,
                             last_activity: Time.zone.now + 1.hour)
    @category.last_topic.user.destroy!
    get category_path(@category)
    assert_response :success
  end

  test 'should visit topics index with post belonged to deleted user' do
    @topic.posts.create!(content: 'some content', user_id: @user.id)
    @category.last_post.user.destroy!
    get category_path(@category)
    assert_response :success
  end

  test 'should visit posts index with topic belonged to deleted user' do
    @category.topics.create!(title: 'some title',
                             content: 'some content',
                             user_id: @user.id,
                             last_activity: Time.zone.now + 1.hour)
    @category.last_topic.user.destroy!
    get topic_path(@category.last_topic)
    assert_response :success
  end

  test 'should visit posts index with post belonged to deleted user' do
    @topic.posts.create!(content: 'some content', user_id: @user.id)
    @category.last_post.user.destroy!
    get topic_path(@category.last_topic, page: @category.last_topic.last_page)
    assert_response :success
  end
end
