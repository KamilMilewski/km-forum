require 'test_helper'

class UserCreateTest < ActionDispatch::IntegrationTest
  def setup
    # deliveries is a global array with all delivered messages. Since it is
    # global we have to clear it before each test.
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid user creation (signup)' do
    get new_user_path
    assert_response :success
    assert_template 'users/new'
    # Test if create user(signup) with invalid data will fail.
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name:                   'valid test name',
          email:                  'valid@user.email',
          permissions:            'villainous_hacker',
          password:               'validpassword',
          password_confirmation:  ''
        }
      }
    end
    assert_template 'users/new'
    assert_flash_notices danger: { count: 1 }
    # Check if there are fields with erroes.
    assert_select 'div.field_with_errors'
  end

  test 'valid user creation (signup) with account activation' do
    get new_user_path
    assert_response :success
    assert_template 'users/new'
    # Test if user create vith valid data vill succeed.
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name:                   'valid test name',
          email:                  'valid@user.email',
          permissions:            'admin',
          password:               'validpassword',
          password_confirmation:  'validpassword'
        }
      }
    end
    # Assure that activation email has been sent.
    assert_equal 1, ActionMailer::Base.deliveries.size
    # Access instance variable @user in corresponding controller action.
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before account activatin and assure it fails.
    log_in_as(user)
    assert_not logged_in?
    # Try to activate account with INVALID token and assure it fails.
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not logged_in?
    # Try to activate account with VALID token but INVALID email and assure it
    # fails.
    get edit_account_activation_path(user.activation_token, email: 'invalid')
    assert_not logged_in?
    # Finally try to activate account with VALID token and email and assure it
    # will succeed.
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert_flash_notices success: { count: 1 }
    assert logged_in?
  end
end
