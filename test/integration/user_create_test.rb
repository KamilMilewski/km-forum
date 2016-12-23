require 'test_helper'

class UserCreateTest < ActionDispatch::IntegrationTest
  def setup
    # deliveries is a global array with all delivered messages. Since it is
    # global we have to clear it before each test.
    ActionMailer::Base.deliveries.clear
  end

  test 'should allow user enter signup page' do
    get new_user_path
    assert_template 'users/new'
    assert_flash_notices
  end

  test 'should allow user create new account' do
    assert_difference 'User.count', 1 do
      post users_path, params: {
        user: {
          name: 'Valid user name',
          email: 'valid@user.email',
          permissions: 'user',
          password: 'uuuuuu',
          password_confirmation: 'uuuuuu'
        }
      }
    end

    # :FIXME assigns should not be used in but I don't have better idea.
    # Newly created user.
    user = assigns(:user)

    # Right after filling the form user is send to main page.
    assert_redirected_to root_path
    follow_redirect!
    assert_template 'categories/index'
    # The notice about account activatin pops up.
    assert_flash_notices info: { count: 1 }

    # Account activation.
    # Assure that activatin email has been sent.

    # :TODO: This no longer works when mail is send by background job.
    # assert_equal 1, ActionMailer::Base.deliveries.size

    # Assert new user isn't activated.
    assert_not user.activated?
    # Try to log in user before activation and assure it fails. He is being
    # redirected to main page with message about account being not activated.
    log_in_as(user)
    assert_not logged_in?
    assert_redirected_to root_path
    follow_redirect!
    assert_flash_notices warning: { count: 1 }
    # Try to activate account with invalid token and assure it fails.
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not logged_in?
    # Try to activate account with valid token/invalid email and assure it fails
    get edit_account_activation_path(user.activation_token, email: 'invalid')
    assert_not logged_in?
    # Assert activatin with valid token and email will succeed.
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    # Right after activating accont user is logged in and redirected to his
    # profile page.
    follow_redirect!
    assert_template 'users/show'
    assert logged_in?
    assert_flash_notices success: { count: 1 }
  end

  test 'sould NOT allow user create new account with invalid data' do
    assert_no_difference 'User.count' do
      post users_path, params: {
        user: {
          name: '',
          email: 'invalid_user.email',
          permissions: 'admin',
          password: 'some password',
          password_confirmation: 'obviously different password'
        }
      }
    end

    # Assure no activation email has been sent.
    assert_equal 0, ActionMailer::Base.deliveries.size

    assert_template 'users/new'
    # Check if there are form fileds with errors.
    assert_select 'div.field_with_errors'
    assert_flash_notices danger: { count: 1 }
  end

  test 'should NOT allow user create account with admin permissions' do
    # Someone adds 'permissions: admin' to other parameters during user creation
    post users_path, params: {
      user: {
        name: 'Valid user name',
        email: 'valid@user.email',
        permissions: 'admin',
        password: 'aaaaaa',
        password_confirmation: 'aaaaaa'
      }
    }

    # :FIXME assigns should not be used in but I don't have better idea.
    # assert that in the end, new user still has only 'user' level permissions.
    assert assigns(:user).user?
  end
end
