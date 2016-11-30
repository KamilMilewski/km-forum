require 'test_helper'

class FriendlyForwardingTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:user)
    # A villain(regular user) who will try to perform action forbidden to him.
    @villain = users(:user_4)

    @category = categories(:first)
    # Resources created by @user.
    @topic = topics(:third)
    @post = posts(:third)
  end

  # Those tests check if user will be forwarded to intended page after log in.
  # Only GET requests are friendly forwarded. PATCH, POST and DELETE requests
  # should get 'access denied' flash notice.

  # EDIT action friendly forwarding tests.
  test 'should friendly forward user edit' do
    get edit_user_path(@user)
    assert_friendly_forwarding_notice
    log_in_as(@user)
    assert_template 'users/edit'
  end

  test 'should friendly forward category edit' do
    get edit_category_path(@category)
    assert_friendly_forwarding_notice
    log_in_as(@admin)
    assert_template 'categories/edit'
  end

  test 'should NOT friendly forward regular user trying to edit category' do
    get edit_category_path(@category)
    assert_friendly_forwarding_notice
    log_in_as(@user)
    assert_access_denied_notice
  end

  test 'should friendly forward user trying to edit his topic' do
    get edit_topic_path(@topic)
    assert_friendly_forwarding_notice
    log_in_as(@user)
    assert_template 'topics/edit'
  end

  test 'should NOT friendly forward user trying to edit foreign topic' do
    get edit_topic_path(@topic)
    assert_friendly_forwarding_notice
    log_in_as(@villain)
    assert_access_denied_notice
  end

  test 'should friendly forward user trying to edit his post' do
    get edit_post_path(@post)
    assert_friendly_forwarding_notice
    log_in_as(@user)
    assert_template 'posts/edit'
  end

  test 'should NOT friendly forward user trying to edit foreign post' do
    get edit_post_path(@post)
    assert_friendly_forwarding_notice
    log_in_as(@villain)
    assert_access_denied_notice
  end

  # NEW action friendly forwarding tests.
  test 'should friendly forward user trying create new category' do
    get new_category_path
    assert_friendly_forwarding_notice
    log_in_as(@admin)
    assert_template 'categories/new'
  end

  test 'should NOT friendly forward regular user trying create new category' do
    get new_category_path
    assert_friendly_forwarding_notice
    log_in_as(@user)
    assert_access_denied_notice
  end

  test 'should friendly forward user trying create new topic' do
    get new_category_topic_path(@category)
    assert_friendly_forwarding_notice
    log_in_as(@user)
    assert_template 'topics/new'
  end

  test 'should friendly forward user trying create new post' do
    get new_topic_post_path(@topic)
    assert_friendly_forwarding_notice
    log_in_as(@user)
    assert_template 'posts/new'
  end

  # INDEX action friendly forwarding tests.
  test 'should friendly forward user trying to access users index' do
    get users_path
    assert_friendly_forwarding_notice
    log_in_as(@user)
    assert_template 'users/index'
  end
end
