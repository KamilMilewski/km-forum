require 'test_helper'

class UserCreateTest < ActionDispatch::IntegrationTest
  test 'valid user creation(signup)' do
    # Get to new user page(signup page) and assure that correct template is used
    get new_user_path
    assert_response :success
    assert_template 'users/new'

    # Test if user create vith valid data vill succeed
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: "valid test name",
          email: "valid@user.email",
          permissions: "admin",
          password: "validpassword",
          password_confirmation: "validpassword"
        }
      }
    end
    # Check if user is logged in after accout creation
    assert is_logged_in?

    assert_response :redirect
    follow_redirect!
    assert_template 'users/show'
    # Check if success flash message shows up
    assert_select 'div.alert-success'
  end

  test 'invalid user creation(signup)' do
    # Get to new user page(signup page and assure that correct template is used)
    get new_user_path
    assert_response :success
    assert_template 'users/new'

    # Test if create user(signup) with invalid data will fail
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: "valid test name",
          email: "valid@user.email",
          permissions: "villainous_hacker",
          password: "validpassword",
          password_confirmation: ""
        }
      }
    end

    assert_template 'users/new'
    #check if error flash massage shows up
    assert_select 'div.alert-danger'

  end
end
