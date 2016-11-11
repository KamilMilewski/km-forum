require 'test_helper'

class TopicCreateTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
    @category = categories(:first)
  end

  test 'valid topic creation' do
    log_in_as(@user)
    # Get to new category page and assure that correct template is used.
    get new_category_topic_path @category
    assert_response :success
    assert_template 'topics/new'
    # Test if create category with valid data vill succeed.
    assert_difference 'Topic.count', 1 do
      post category_topics_path(@category), params: { topic: {
        title: 'test category',
        content: 'test description'
      } }
    end
    assert_response :redirect
    follow_redirect!
    assert_template 'topics/show'
    # Check if success flash massage shows up.
    assert_select 'div.alert-success'
  end

  test 'invalid topic creation' do
    log_in_as(@user)
    # Get to new category page and assure that correct template is used.
    get new_category_topic_path @category
    assert_response :success
    assert_template 'topics/new'
    # Test if create category with valid data will fail.
    assert_no_difference 'Topic.count' do
      post category_topics_path(@category), params: { topic: {
        title: "\t",
        content: "\t"
      } }
    end
    assert_template 'topics/new'
    # Check if error flash massage shows up.
    assert_select 'div.alert-danger'
  end

  test 'trying to create a topic as another user' do
    log_in_as(@user)
    # id of the user we want maliciously impersonate during post creation.
    target_user_id = 6
    get new_category_topic_path @category
    post category_topics_path(@category), params: { topic: {
      content: 'some content',
      user_id: target_user_id
    } }
    topic = assigns(:topic)
    # Assert that newly created post belongs to logged in user.
    assert_equal topic.user_id, @user.id
  end
end
