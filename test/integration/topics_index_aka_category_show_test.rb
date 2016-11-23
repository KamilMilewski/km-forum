require 'test_helper'

class TopicsIndexAkaCategoryShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @moderator = users(:moderator)
    @user = users(:user)

    # Index page will display topics created in @category.
    @category = categories(:first)

    # Topics per page.
    @per_page = 10
  end

  test 'should access topics index page, as an admin' do
    log_in_as(@admin)

    assert_basic_layout

    # Assert there is link to show, edit & delete actions for each topic. Admin
    # should be able to edit and delete every topic.
    @category.topics.paginate(page: 1, per_page: @per_page).each do |topic|
      # There are two links that match topic_path(topic). One for show action
      # and one for delete.
      assert_select 'a[href=?]', topic_path(topic), count: 2
      # Make sure that amongs those two one is for delete action.
      assert_topic_buttons(1, topic)
    end
  end

  test 'should access topics index page, as a moderator' do
    log_in_as(@moderator)

    assert_basic_layout

    # Assert there is link to show, edit & delete actions for each topic
    # excluded admin's topics. In first 10 fixtures only the first topic
    # belongs to an admin.
    @category.topics.paginate(page: 1, per_page: @per_page).each do |topic|
      if topic.user.admin?
        # Moderator can only access show action of admin's topics:
        assert_select 'a[href=?]', topic_path(topic), count: 1
        assert_topic_buttons(0, topic)
      else
        # Moderator can edit and delete all other topics:
        assert_select 'a[href=?]', topic_path(topic), count: 2
        # Make sure that amongs those two one is for delete action.
        assert_topic_buttons(1, topic)
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
      if !@user.owner_of(topic)
        # Users can only access show action of foreign topics:
        assert_select 'a[href=?]', topic_path(topic), count: 1
        assert_topic_buttons(0, topic)
      else
        # Users can also edit and delete their own topics:
        assert_select 'a[href=?]', topic_path(topic), count: 2
        # Make sure that amongs those two one is for delete action.
        assert_topic_buttons(1, topic)
      end
    end
  end

  test 'should access topics index page, as a not logged in user' do
    get category_path(@category)

    assert_basic_layout

    # Assert there is link only to show for each topic. Not logged in users
    # cant't edit or delete topics.
    @category.topics.paginate(page: 1, per_page: @per_page).each do |topic|
      assert_select 'a[href=?]', topic_path(topic), count: 1
      assert_topic_buttons(0, topic)
    end
  end

  # Helper methods speciffic only to this  file:

  # No matter what this layout should apply.
  def assert_basic_layout
    get category_path(@category)
    # Topics index is actually category show.
    assert_template 'categories/show'
    # Assert there are two will_paginate controls on the page.
    assert_select 'ul.pagination', count: 2
    # Assert there is no flash messages.
    assert_flash_notices
  end

  # Assert if there are edit & delete topic buttons.
  # Assert if there are edit & delete topic buttons.
  def assert_topic_buttons(count, topic)
    assert_select 'a[data-method=delete][href=?]', topic_path(topic),
                  count: count
    assert_select 'a[href=?]', edit_topic_path(topic), count: count
  end
end
