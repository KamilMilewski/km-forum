require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "KM-Forum"
    @user = users(:user)
    @other_user = users(:user_1)
  end

  test "should get user index page" do
    get users_path
    assert_response :success
    assert_select "title", "User index | #{@base_title}"
  end

  test "should redirect user edit page when not logged in" do
    get edit_user_path(@user)
    assert_response :redirect
    follow_redirect!
    assert_template 'sessions/new'
  end

  test "should redirect user patch request when not logged in" do
    patch user_path(@user), params: {
      user: {
        name: 'some valid name',
        email: 'valid@email.com'
      }
    }
    assert_response :redirect
    follow_redirect!
    assert_template 'sessions/new'
  end

  test "should redirect when accessing different user edit profile page" do
    log_in_as(@user, password: 'uuuuuu')
    get edit_user_path(@other_user)
    assert_redirected_to root_url
  end

  test "should redirect when issuing patch request to different user" do
    log_in_as(@user, password: 'uuuuuu')
    patch user_path(@other_user), params: {
      user: {
        name: 'some valid name',
        email: 'valid@email.com'
      }
    }
    assert_redirected_to root_url
  end

end
