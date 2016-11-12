require 'test_helper'

class SessionTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
  end

  test 'user login with valid data followed by logout' do
    # Get to login path
    get login_path
    assert_template 'sessions/new'

    # Try to login with valid data and assure it succeed
    post login_path, params: {
      session: {
        email: users(:admin).email,
        password: 'aaaaaa'
      }
    }
    assert logged_in?

    # Check if proper page is displayed
    assert_response :redirect
    follow_redirect!
    # Check if proper flash notice is displayed
    assert_select 'div.alert-success'
    # Check if proper links are rendered
    assert_select 'a[href=?]', login_path, count: 0
    # Dropdown menu
    assert_select 'a[href=?]', logout_path, count: 1
    assert_select 'a[href=?]', user_path(users(:admin)), count: 1
    assert_select 'a[href=?]', edit_user_path(users(:admin)), count: 1

    assert_select 'a[href=?]', users_path, count: 1

    # Try to logout
    delete logout_path
    assert_not logged_in?

    # Check if proper page is displayed
    assert_redirected_to root_path
    follow_redirect!

    # Check if proper flash notice is displayed
    assert_select 'div.alert-success'
    # Check if proper links are rendered
    assert_select 'a[href=?]', login_path, count: 1
    # Dropdown menu
    assert_select 'a[href=?]', logout_path, count: 0
    assert_select 'a[href=?]', user_path(users(:admin)), count: 0
    assert_select 'a[href=?]', edit_user_path(users(:admin)), count: 0
    assert_select 'a[href=?]', users_path, count: 0
  end

  test 'user login with invalid data' do
    # Get to login path
    get login_path
    assert_template 'sessions/new'

    # Try to login with invalid data and assure it fails
    post login_path, params: {
      session: {
        email: users(:admin).email,
        password: 'wrong password'
      }
    }
    assert_not logged_in?

    # Check if proper page is displayed
    assert_template 'sessions/new'
    # Check if proper flash notice is displayed
    assert_select 'div.alert-danger'
    # Check if proper links are rendered
    assert_select 'a[href=?]', login_path
    assert_select 'a[href=?]', logout_path, count: 0
  end

  test 'login with remember_me checkbox checked' do
    log_in_as(@admin, remember_me_checkbox: '1')
    assert_not_nil cookies['remember_token']
  end

  test 'login with remember_me checkbox unchecked' do
    log_in_as(@admin, remember_me_checkbox: '0')
    assert_nil cookies['remember_token']
  end
end
