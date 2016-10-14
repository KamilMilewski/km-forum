require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
  end

  test "successful user edit" do
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

  test "unsuccessful user edit" do

  end
end
