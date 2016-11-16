require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:user)
    # This user is unfortunate enough to be victim of other's users villanous
    # deeds.
    @unfortunate_user = users(:user)
    # Just regular villain(user) who will try to perform action forbidden to him
    @villanous_user = users(:user_4)
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

  test 'villanous attempt to edit another user by non admim should fail' do
    log_in_as(@villanous_user)
    get users_path

    # Try to get to another user edit page:
    get edit_user_path(@unfortunate_user)
    assert_redirected_to root_path

    # New valid values for user name and email fields.
    new_user_name = 'new valid user name'
    new_user_email = 'new_valid@user.email'

    # Request to edit given user record in db.
    patch user_path(@unfortunate_user), params: {
      user: {
        name: new_user_name,
        email: new_user_email
      }
    }

    assert_redirected_to root_path
    # Assert no changes to user has ben made.
    @unfortunate_user.reload
    assert_not_equal new_user_name, @unfortunate_user.name
    assert_not_equal new_user_email, @unfortunate_user.email
  end

  test 'sinister attempt to edit user by non logged in villain' do
    # New valid values for user name and email fields.
    new_user_name = 'new valid user name'
    new_user_email = 'new_valid@user.email'

    # Request to edit given user record in db.
    patch user_path(@unfortunate_user), params: {
      user: {
        name: new_user_name,
        email: new_user_email
      }
    }
    assert_redirected_to root_path

    # Assert no changes to user has ben made.
    @unfortunate_user.reload
    assert_not_equal new_user_name, @unfortunate_user.name
    assert_not_equal new_user_email, @unfortunate_user.email
  end
end
