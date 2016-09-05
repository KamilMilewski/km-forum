require 'test_helper'

class SessionTest < ActionDispatch::IntegrationTest
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
    assert is_logged_in?

    # Check if proper page is displayed
    assert_response :redirect
    follow_redirect!
    # Check if proper flash notice is displayed
    assert_select 'div.alert-success'
    # Check if proper links are rendered
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(users(:admin))

    # Try to logout
    delete logout_path
    assert_not is_logged_in?

    # Check if proper page is displayed
    assert_redirected_to root_path
    follow_redirect!

    # Check if proper flash notice is displayed
    assert_select 'div.alert-success'
    # Check if proper links are rendered
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
  end

  test 'user login with invalid data' do
    #Get to login path
    get login_path
    assert_template 'sessions/new'

    # Try to login with invalid data and assure it fails
    post login_path, params: {
      session: {
          email: users(:admin).email,
          password: 'wrong password'
        }
      }
    assert_not is_logged_in?

    # Check if proper page is displayed
    assert_template 'sessions/new'
    # Check if proper flash notice is displayed
    assert_select 'div.alert-danger'
    # Check if proper links are rendered
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
  end
end
