require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
    @admin = users(:admin)
  end

  test 'successful user edit' do
    # User has to be logged in before entering edit page.
    log_in_as(@user)

    # Get to user edit page.
    get edit_user_path(@user)
    assert_template 'users/edit'

    # New valid values for user name and email fields.
    new_user_name = 'new valid user name'
    new_user_email = 'new_valid@user.email'

    # Request to edit given user record in db.
    patch user_path(@user), params: {
      user: {
        name: new_user_name,
        email: new_user_email
      }
    }

    # Reload user from db. Thanks to this @user object will have updated
    # attributes after we issued patch request to edit him.
    @user.reload

    # Assert that @user fields has been correctly updated.
    assert_equal new_user_name, @user.name
    assert_equal new_user_email, @user.email

    # Assert redirect to user profile.
    assert_response :redirect
    follow_redirect!
    assert_template 'users/show'

    # Assert correct flash message.
    assert_select 'div.alert-success'
  end

  test 'successful another user edit, as an admin' do
    log_in_as(@admin)

    # Get to user edit page. Admin should be allowed to edit other's users
    # profiles.
    get edit_user_path(@user)
    assert_template 'users/edit'

    # New valid values for user name and email fields.
    new_user_name = 'new valid user name'
    new_user_email = 'new_valid@user.email'

    # Request to edit given user record in db.
    patch user_path(@user), params: {
      user: {
        name: new_user_name,
        email: new_user_email
      }
    }

    # Reload user from db. Thanks to this @user object will have updated
    # attributes after we issued patch request to edit him.
    @user.reload

    # Assert that @user fields has been correctly updated.
    assert_equal new_user_name, @user.name
    assert_equal new_user_email, @user.email

    # Assert redirect to user profile.
    assert_response :redirect
    follow_redirect!
    assert_template 'users/show'
  end

  test 'unsuccessful user edit' do
    # User has to be logged in before entering edit page.
    log_in_as(@user)

    # Get to user edit page.
    get edit_user_path(@user)
    assert_template 'users/edit'

    # New valid values for user name and email fields.
    new_user_name = ''
    new_user_email = 'new_invalid_user.email'

    # Request to edit given user record in db.
    patch user_path(@user), params: {
      user: {
        name: new_user_name,
        email: new_user_email
      }
    }

    # Assert edit form is rerendered.
    assert_template 'users/edit'

    # Check if error flash message shows up.
    assert_select 'div.alert-danger'

    # Assert no changes to user has ben made.
    @user.reload
    assert_not_equal new_user_name, @user.name
    assert_not_equal new_user_email, @user.email
  end
end
