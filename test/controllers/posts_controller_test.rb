require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = 'KM-Forum'
    @user = users(:user)
  end

  test 'should get new' do
    log_in_as(@user)
    get new_topic_post_url(topics(:one))
    assert_response :success
    assert_select 'title', "New post | #{@base_title}"
    assert_template 'posts/new'
  end

  test 'should get edit' do
    log_in_as(@user)
    get edit_post_url(posts(:one))
    assert_response :success
    assert_select 'title', "Edit post | #{@base_title}"
    assert_template 'posts/edit'
  end
end
