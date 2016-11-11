require 'test_helper'

class PostsIndexAkaTopicShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @topic = topics(:first)
  end

  test 'posts index page(topic show) with will_paginate, as an admin' do
    # Get to the login page and log in user.
    get login_path
    log_in_as(@admin, password: 'aaaaaa')
    # Get to the topic show page(posts index) and assure correct template.
    get topic_path(@topic)
    assert_response :success
    assert_template 'topics/show'
    # Assure there are two will_paginate controls on the page.
    assert_select 'ul.pagination', count: 2

    posts = Post.paginate(page: 1, per_page: 10)
    posts.each do |post|
      # Assure there is link to edit and delete actions for each post.
      assert_select 'a[href=?]', edit_post_path(post), count: 1
      assert_select 'a[data-method=delete][href=?]', post_path(post), count: 1
      # Assure there is each post's content.
      assert_select 'p', text: post.content, count: 1
    end
  end
end
