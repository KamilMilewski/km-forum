require 'test_helper'

class TopicsIndexAkaCategoryShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:user)
    @category = categories(:one)
  end

  test 'topic index page(category show) with will_paginate, as an admin' do
    # Get to the login page and log in user.
    get login_path
    log_in_as(@admin, password: 'aaaaaa')
    # Get to the category show page(topic index) and assure correct template.
    get category_path(@category)
    assert_response :success
    assert_template 'categories/show'
    # Assure there are two will_paginate controls on the page.
    assert_select 'ul.pagination', count: 2

    # Assure there is link to show, edit and delete actions for each topic.
    topics = Topic.paginate(page: 1, per_page: 10)
    topics.each do |topic|
      assert_select 'a[href=?]', topic_path(topic)
      assert_select 'a[href=?]', edit_topic_path(topic), count: 1
      assert_select 'a[data-method=delete][href=?]', topic_path(topic), count: 1
    end
  end
end
