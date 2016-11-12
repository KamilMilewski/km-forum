require 'test_helper'

class PostsIndexAkaTopicShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @topic = topics(:first)
  end

  test 'posts index page(topic show) with will_paginate, as an admin' do
    # Get to the login page and log in admin.
    get login_path
    log_in_as(@admin)
    # Get to the topic show page(posts index) and assure correct template.
    get topic_path(@topic)
    assert_response :success
    assert_template 'topics/show'
    # Assure there are two will_paginate controls on the page.
    assert_select 'ul.pagination', count: 2

    # Assure there is topic as a first post.
    # title section contains title of the topic...
    assert_select 'h4', text: /#{@topic.title}/, count: 1
    # and content section contains topic content
    assert_select 'p', text: @topic.content, count: 1
    # Assure there is link to 'edit' and 'delete' actions for each post.
    assert_select 'a[href=?]', edit_topic_path(@topic), count: 1
    assert_select 'a[data-method=delete][href=?]', topic_path(@topic),
                  count: 1

    @topic.posts.paginate(page: 1, per_page: 10)
          .each do |post|
      # Assure there is each post's content.
      assert_select 'p', text: post.content, count: 1
      # Assure there is link to 'edit' and 'delete' actions for each post.
      assert_select 'a[href=?]', edit_post_path(post), count: 1
      assert_select 'a[data-method=delete][href=?]', post_path(post), count: 1
    end
  end

  test 'posts index page(topic show) with will_paginate, as an regular user' do
    # Get to the login page and log in regular user.
    get login_path
    log_in_as(@user)
    # Get to the topic show page(posts index) and assure correct template.
    get topic_path(@topic)
    assert_response :success
    assert_template 'topics/show'
    # Assure there are two will_paginate controls on the page.
    assert_select 'ul.pagination', count: 2

    # Assure there is topic as a first post.
    # title section contains title of the topic...
    assert_select 'h4', text: /#{@topic.title}/, count: 1
    # and content section contains topic content
    assert_select 'p', text: @topic.content, count: 1
    # If the current logged in user...
    if @user.owner_of(@topic)
      # Is owner of the topic then he should see 'edit' and 'delete' links on
      # a given topic...
      assert_select 'a[href=?]', edit_topic_path(@topic), count: 1
      assert_select 'a[data-method=delete][href=?]', topic_path(@topic),
                    count: 1
    else
      # And shouldn't be able to see such links on other users topics.
      assert_select 'a[href=?]', edit_topic_path(@topic), count: 0
      assert_select 'a[data-method=delete][href=?]', topic_path(@topic),
                    count: 0
    end

    @topic.posts.paginate(page: 1, per_page: 10)
          .each do |post|
      # Assure there is each post's content.
      assert_select 'p', text: post.content, count: 1
      # If the current logged in user...
      if @user.owner_of(post)
        # Is owner of the post then he should see 'edit' & 'delete' links on a
        # given post...
        assert_select 'a[href=?]', edit_post_path(post), count: 1
        assert_select 'a[data-method=delete][href=?]', post_path(post), count: 1
      else
        # And shouldn't be able to see such links on other users posts.
        assert_select 'a[href=?]', edit_post_path(post), count: 0
        assert_select 'a[data-method=delete][href=?]', post_path(post), count: 0
      end
    end
  end

  test 'posts index page(topic show) with will_paginate, as non logged user' do
    # Go straight to the topic show page
    get topic_path(@topic)
    assert_response :success
    assert_template 'topics/show'
    # Assure there are two will_paginate controls on the page.
    assert_select 'ul.pagination', count: 2

    # Assure there is topic as a first post.
    # title section contains title of the topic...
    assert_select 'h4', text: /#{@topic.title}/, count: 1
    # and content section contains topic content
    assert_select 'p', text: @topic.content, count: 1
    # There shouldn't be any delete/edit buttons
    assert_select 'a[href=?]', edit_topic_path(@topic), count: 0
    assert_select 'a[data-method=delete][href=?]', topic_path(@topic), count: 0

    @topic.posts.paginate(page: 1, per_page: 10)
          .each do |post|
      # Assure there is each post's content.
      assert_select 'p', text: post.content, count: 1
      # There shouldn't be any delete/edit buttons
      assert_select 'a[href=?]', edit_post_path(post), count: 0
      assert_select 'a[data-method=delete][href=?]', post_path(post), count: 0
    end
  end
end
