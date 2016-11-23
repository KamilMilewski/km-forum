require 'test_helper'

class PostsIndexAkaTopicShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @moderator = users(:moderator)
    @user = users(:user)

    # Index page will display posts created in @topic.
    # @topic is created by admin.
    @topic = topics(:first)
    @moderators_topic = topics(:second)
    @users_topic = topics(:third)
    @anothers_user_topic = topics(:topic_4)

    # Topics per page.
    @per_page = 10
  end

  test 'should access posts index page 1, as an admin' do
    log_in_as(@admin)

    assert_basic_layout

    assert_topic_body(1)

    # Assert there is link to edit & delete action for topic.
    assert_topic_buttons(1, @topic)

    @topic.posts.paginate(page: 1, per_page: @per_page).each do |post|
      # Assert there is post content for each post.
      assert_select 'p', class: 'post-content', text: /#{post.content}/
      # Assert there is link to edit & delete actions for each post. Admin
      # should be able to edit and delete every post.
      assert_post_buttons(1, post)
    end
  end

  test 'should access posts index page 1, as a moderator' do
    log_in_as(@moderator)

    assert_basic_layout

    assert_topic_body(1)

    # @topic belongs to @admin. Assert there is no link to edit & delete action
    # for @topic since moderator should not see them for admin's topic.
    assert_topic_buttons(0, @topic)

    @topic.posts.paginate(page: 1, per_page: @per_page).each do |post|
      # Assert there is post content for each post.
      assert_select 'p', class: 'post-content', text: /#{post.content}/
      # Assert there is link to edit & delete actions for each post excluded
      # admin's posts. In first 10 fixtures only first post belongs to @admin.
      assert_post_buttons(post.user.admin? ? 0 : 1, post)
    end
  end

  test 'should access posts index page 1, as a user' do
    log_in_as(@user)

    assert_basic_layout

    assert_topic_body(1)

    # @topic belongs to @admin. Assert there is no link to edit & delete action
    # for @topic since regular user should not see them for foreign topic.
    assert_topic_buttons(0, @topic)
    # Assert there are post edit & delete links only for posts given user owns.
    # In first 10 fixtures only third post belongs to @user.
    @topic.posts.paginate(page: 1, per_page: @per_page).each do |post|
      # Assert there is post content for each post.
      assert_select 'p', class: 'post-content', text: /#{post.content}/
      # Assert there is link to edit & delete actions for @user's posts. In
      # first 10 fixtures only third post belongs to @user.
      assert_post_buttons(@user.owner_of(post) ? 1 : 0, post)
    end
  end

  test 'shoudl access posts index page 1, as a not logged in user' do
    assert_basic_layout

    assert_topic_body(1)

    # Assert there is no link to edit & delete topic action for not logged in
    # user.
    assert_topic_buttons(0, @topic)

    @topic.posts.paginate(page: 1, per_page: @per_page).each do |post|
      # Assert there is post content for each post.
      assert_select 'p', class: 'post-content', text: /#{post.content}/
      # Assert there is no link to edit & delete post action for not logged in
      # user.
      assert_post_buttons(0, post)
    end
  end

  # These will be kind of a complementary tests. They are needed since displayed
  # topic can belong not only to @admin. Besides we need to check if page: 2
  # because it is different from page: 1 (desen't conraints topic as the first
  # post).
  test 'topic content should be visible only on page: 1' do
    # Assert there is no topic content on second page:
    get topic_path(@topic), params: { page: 2 }
    assert_topic_body(0)
    # And on third page...
    get topic_path(@topic), params: { page: 3 }
    assert_topic_body(0)
    # Assert there is post content for each post.
    @topic.posts.paginate(page: 3, per_page: @per_page).each do |post|
      assert_select 'p', class: 'post-content', text: /#{post.content}/
    end
  end

  test 'should allow user edit & delete his own topic' do
    log_in_as(@user)
    get topic_path(@users_topic)
    assert_topic_buttons(1, @users_topic)
  end

  test 'should allow moderator edit & delete user\'s topic' do
    log_in_as(@moderator)
    get topic_path(@users_topic)
    assert_topic_buttons(1, @users_topic)
  end

  test 'should NOT allow user edit & delete foreign topic' do
    log_in_as(@user)
    get topic_path(@anothers_user_topic)
    assert_topic_buttons(0, @anothers_user_topic)
  end

  # Helper methods speciffic only to this file:

  # No mather what this layout should apply.
  def assert_basic_layout
    get topic_path(@topic)
    # Posts index is actually topic show.
    assert_template 'topics/show'
    # Assert there ate two will_paginate controls on the page.
    assert_select 'ul.pagination', count: 2
    # Assert there is no flash messages.
    assert_flash_notices
  end

  # Assert if there is topic title & content.
  def assert_topic_body(count)
    assert_select 'h4', id: 'topic-title', text: /#{@topic.title}/,
                        count: count
    assert_select 'p', id: 'topic-content', text: /#{@topic.content}/,
                       count: count
  end

  # Assert if there are edit & delete topic buttons.
  def assert_topic_buttons(count, topic)
    assert_select 'a[data-method=delete][href=?]', topic_path(topic),
                  count: count
    assert_select 'a[href=?]', edit_topic_path(topic), count: count
  end

  # Assert if there are edit & delete post buttons.
  def assert_post_buttons(count, post)
    assert_select '[data-method=delete][href=?]', post_path(post), count: count
    assert_select 'a[href=?]', edit_post_path(post), count: count
  end
end
