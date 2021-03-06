require 'test_helper'

class UserEditTest < ActionDispatch::IntegrationTest
  def setup
    # Admins can edit all users. Moderators can edit all users but admin. users
    # can edit only their own profiles.
    @admin = users(:admin)
    @moderator = users(:moderator)
    @user = users(:user)
    @accepted_users = [@admin, @moderator, @user]

    # A villain(regular user) who will try to perform action forbidden to him.
    @villain = users(:user_4)

    # New valid values for user account.
    @new_email = 'new@valid.email'
    @new_name = 'new valid name'
  end

  test 'should allow admin, mod. and profile owner enter user\'s edit page' do
    # users who can visit edit page: admin, moderator and user who owns profiles
    @accepted_users.each do |user|
      log_in_as(user)

      get edit_user_path(@user)
      assert_template 'users/edit'
      assert_flash_notices
    end
  end

  test 'should NOT allow moderator enter admin\'s profile edit page' do
    log_in_as(@moderator)

    get edit_user_path(@admin)
    assert_access_denied_notice
  end

  test 'should NOT allow user enter another user\'s profile edit page' do
    log_in_as(@villain)

    get edit_user_path(@user)
    assert_access_denied_notice
  end

  test 'should NOT allow not logged in user enter user\'s profile edit page' do
    get edit_user_path(@user)
    assert_friendly_forwarding_notice
  end

  test 'should allow admin, moderator and profile owner update user' do
    @accepted_users.each do |user|
      log_in_as(user)

      patch user_path(@user), params: {
        user: {
          email: @new_email,
          name: @new_name
        }
      }

      # Assert user profile has been updated.
      @user.reload
      assert_equal @new_email, @user.email
      assert_equal @new_name, @user.name

      assert_redirected_to user_path(@user)
      follow_redirect!
      assert_template 'users/show'
      assert_flash_notices success: { count: 1 }
    end
  end

  test 'should NOT allow to update user\'s profile with invalid data' do
    @accepted_users.each do |user|
      log_in_as(user)

      @new_email = 'new invalid email @ :*'
      @new_name = ''

      patch user_path(@user), params: {
        user: {
          email: @new_email,
          name: @new_name
        }
      }

      # Assert user profile has not been updated.
      @user.reload
      assert_not_equal @new_email, @user.email
      assert_not_equal @new_name, @user.name

      assert_template 'users/edit'
      # Check if there are form fileds with errors.
      assert_select 'div.field_with_errors'
      assert_flash_notices danger: { count: 1 }
    end
  end

  test 'should NOT allow moderator edit admin\'s profile' do
    log_in_as(@moderator)

    patch user_path(@admin), params: {
      user: {
        email: @new_email,
        name: @new_name
      }
    }

    # Assert user profile has NOT been updated
    @admin.reload
    assert_not_equal @new_email, @admin.email
    assert_not_equal @new_name, @admin.name

    assert_access_denied_notice
  end

  test 'should NOT allow user edit another user\'s profile' do
    log_in_as(@villain)

    patch user_path(@user), params: {
      user: {
        email: @new_email,
        name: @new_name
      }
    }

    # Assert user profile has NOT been updated.
    @user.reload
    assert_not_equal @new_email, @user.email
    assert_not_equal @new_name, @user.name

    assert_access_denied_notice
  end

  test 'should NOT allow not logged in user edit another user\'s profile' do
    patch user_path(@user), params: {
      user: {
        email: @new_email,
        name: @new_name
      }
    }

    # Assert user has NOT been updated.
    @user.reload
    assert_not_equal @new_email, @user.email
    assert_not_equal @new_name, @user.name

    assert_access_denied_notice
  end
end
