require 'test_helper'

class TopicsIndexAkaCategoryShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @moderator = users(:moderator)
    @user = users(:user)

    # Index page will display topics created in @category.
    @category = categories(:first)

    # Topics per page.
    @per_page = KmForum::TOPICS_PER_PAGE
  end

  test 'should access topics index page, as an admin' do
    log_in_as(@admin)

    assert_basic_layout

    # Assert there is link to show, edit & delete actions for each topic. Admin
    # should be able to edit and delete every topic.
    @category.topics.paginate(page: 1, per_page: @per_page).each do |topic|
      assert_topic_body_for(topic)
      # There are three links that match topic_path(topic). Two for show action
      # and one for delete.
      # Refular link to topic.
      assert_select 'a[href=?]', topic_path(topic)
      assert_edit_delete_links_for(topic, links_count: 1)
    end
  end

  test 'should access topics index page, as a moderator' do
    log_in_as(@moderator)

    assert_basic_layout

    # Assert there is link to show, edit & delete actions for each topic
    # excluded admin's topics. In first 10 fixtures only the first topic
    # belongs to an admin.
    @category.topics.paginate(page: 1, per_page: @per_page).each do |topic|
      assert_topic_body_for(topic)
      assert_select 'a[href=?]', topic_path(topic)
      if topic.user.admin?
        # Moderator can only access show action of admin's topics:
        assert_edit_delete_links_for(topic, links_count: 0)
      else
        # Moderator can edit and delete all other topics:
        assert_edit_delete_links_for(topic, links_count: 1)
      end
    end
  end

  test 'should access topics index page, as a user' do
    log_in_as(@user)

    assert_basic_layout

    # Assert there is link to show for each topic. Edit & delete links only
    # for given user own topics. In first 10 fixtures only third topic belongs
    # to user.
    @category.topics.paginate(page: 1, per_page: @per_page).each do |topic|
      assert_topic_body_for(topic)
      assert_select 'a[href=?]', topic_path(topic)
      if !@user.owner_of(topic)
        # Users can only access show action of foreign topics:
        assert_edit_delete_links_for(topic, links_count: 0)
      else
        # Users can also edit and delete their own topics:
        assert_edit_delete_links_for(topic, links_count: 1)
      end
    end
  end

  test 'should access topics index page, as a not logged in user' do
    get category_path(@category)

    assert_basic_layout

    # Assert there is link only to show for each topic. Not logged in users
    # cant't edit or delete topics.
    @category.topics.paginate(page: 1, per_page: @per_page).each do |topic|
      assert_topic_body_for(topic)
      assert_select 'a[href=?]', topic_path(topic)
      assert_edit_delete_links_for(topic, links_count: 0)
    end
  end

  # Helper methods speciffic only to this file:

  # No matter what this layout should apply.
  def assert_basic_layout
    get category_path(@category)
    # Topics index is actually category show.
    assert_template 'topics/index'
    # Assert there are two will_paginate controls on the page.
    assert_select 'ul.pagination', count: 1
    # Assert there is no flash messages.
    assert_flash_notices
  end

  def assert_topic_body_for(topic, present: true)
    if present
      assert_match      CGI.escapeHTML(topic.title),    response.body
    else
      assert_no_match   CGI.escapeHTML(topic.title),    response.body
    end
  end
end
