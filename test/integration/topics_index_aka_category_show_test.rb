require 'test_helper'

class TopicsIndexAkaCategoryShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @category = categories(:first)
  end

  test 'topics index page(category show) with will_paginate, as an admin' do
    # Get to the login page and log in user.
    get login_path
    log_in_as(@admin, password: 'aaaaaa')
    # Get to the category show page(topics index) and assure correct template.
    get category_path(@category)
    assert_response :success
    assert_template 'categories/show'
    # Assure there are two will_paginate controls on the page.
    assert_select 'ul.pagination', count: 2

    # Assure there is link to 'show', 'edit' & 'delete' actions for each topic.
    @category.topics.paginate(page: 1, per_page: 10)
             .each do |topic|
      assert_select 'a[href=?]', topic_path(topic)
      assert_select 'a[href=?]', edit_topic_path(topic), count: 1
      assert_select 'a[data-method=delete][href=?]', topic_path(topic), count: 1
    end
  end

  test 'topics index page(category show) with will_paginate, ' \
       'as an regular user' do
    # Get to the login page and log in regular user.
    get login_path
    log_in_as(@user, password: 'uuuuuu')
    # Get to the category show page(topics index) and assure correct template.
    get category_path(@category)
    assert_response :success
    assert_template 'categories/show'
    # Assure there are two will_paginate controls on the page.
    assert_select 'ul.pagination', count: 2

    @category.topics.paginate(page: 1, per_page: 10)
             .each do |topic|
      # Assure there is each topic's content.
      assert_select 'p', text: topic.content, count: 1
      # If the current logged in user...
      if @user.owner_of(topic)
        # is owner of the topic then he should see 'edit' and 'delete' links on
        # a given topic...
        assert_select 'a[href=?]', edit_topic_path(topic), count: 1
        assert_select 'a[data-method=delete][href=?]', topic_path(topic),
                      count: 1
      else
        # and shouldn't be able to see such links on other users topics.
        assert_select 'a[href=?]', edit_topic_path(topic), count: 0
        assert_select 'a[data-method=delete][href=?]', topic_path(topic),
                      count: 0
      end
    end
  end

  test 'topics index page(category show) with will_paginate,' \
       'as non logged user' do
    # Go straight to the category show page
    get category_path(@category)
    assert_response :success
    assert_template 'categories/show'
    # Assure there are two will_paginate controls on the page.
    assert_select 'ul.pagination', count: 2

    @category.topics.paginate(page: 1, per_page: 10)
             .each do |topic|
      # Assure there is each post's content.
      assert_select 'p', text: topic.content, count: 1
      # There shouldn't be any delete/edit buttons
      assert_select 'a[href=?]', edit_topic_path(topic), count: 0
      assert_select 'a[data-method=delete][href=?]', topic_path(topic), count: 0
    end
  end
end
