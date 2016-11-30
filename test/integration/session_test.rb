require 'test_helper'

class SessionTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
  end

  test 'should allow login with valid data' do
    # Get to login path.
    get login_path
    assert_template 'sessions/new'

    # Try to login with valid data and assure it succeed.
    log_in_as(@user)
    assert logged_in?

    # Check if proper page is displayed.
    assert_template 'categories/index'

    # Check if proper links are rendered.
    assert_select 'a[href=?]', login_path, count: 0
    # Dropdown menu.
    assert_select 'a[href=?]', logout_path, count: 1
    assert_select 'a[href=?]', user_path(@user), count: 1
    assert_select 'a[href=?]', edit_user_path(@user), count: 1
    assert_select 'a[href=?]', users_path, count: 1

    assert_flash_notices success: { count: 1 }
  end

  test 'should allow logout' do
    log_in_as(@user)

    # Try to logout.
    delete logout_path
    assert_not logged_in?

    # Check if proper page is displayed.
    assert_redirected_to root_path
    follow_redirect!

    # Check if proper links are rendered.
    assert_select 'a[href=?]', login_path, count: 1
    # Dropdown menu.
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(@user), count: 0
    assert_select 'a[href=?]', edit_user_path(@user), count: 0
    assert_select 'a[href=?]', users_path, count: 0

    assert_flash_notices success: { count: 1 }
  end

  test 'should NOT allow login with invalid data' do
    # Get to login path.
    get login_path
    assert_template 'sessions/new'

    # Try to login with invalid data and assure it fails.
    log_in_as(@user, password: 'some invalid password')
    assert_not logged_in?

    # Check if proper page is displayed.
    assert_template 'sessions/new'

    # Check if proper links are rendered.
    assert_select 'a[href=?]', login_path, count: 1
    assert_select 'a[href=?]', logout_path, count: 0

    assert_flash_notices danger: { count: 1 }
  end

  test 'should allow login with remember_me checkbox checked' do
    log_in_as(@user, remember_me_checkbox: '1')
    assert_not_nil cookies['remember_token']
  end

  test 'should allow login with remember_me checkbox unchecked' do
    log_in_as(@user, remember_me_checkbox: '0')
    assert_nil cookies['remember_token']
  end
end
