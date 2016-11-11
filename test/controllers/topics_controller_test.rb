require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = 'KM-Forum'
    @user = users(:user)
    @topic = topics(:first)
  end

  test 'should get show' do
    get topic_url(@topic)
    assert_response :success
    assert_select 'title', "#{@topic.title} | #{@base_title}"
    assert_template 'topics/show'
  end

  test 'should get new' do
    log_in_as(@user)
    get new_category_topic_url(categories(:first))
    assert_response :success
    assert_select 'title', "New topic | #{@base_title}"
    assert_template 'topics/new'
  end

  test 'should get edit' do
    log_in_as(@user)
    get edit_topic_url(@topic)
    assert_response :success
    assert_select 'title', "Edit topic | #{@base_title}"
    assert_template 'topics/edit'
  end
end
