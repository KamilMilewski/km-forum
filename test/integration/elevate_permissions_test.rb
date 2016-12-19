require 'test_helper'

class ElevatePermissionsTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @moderator = users(:moderator)
    @user = users(:user)

    @villain = users(:user_4)
  end

  test 'admin should be able elevate user permissions' do
    log_in_as @admin

    get edit_user_path(@user)
    # Assert there is tag for user permissions.
    assert_select 'select[id=user_permissions]'

    # Try to change permissions.
    patch user_path(@user), params: {
      user: {
        permissions: 'moderator'
      }
    }

    # Assert it succeeded.
    assert_equal 'moderator', @user.reload.permissions
  end

  test 'moderator should NOT be able to elevate user permissions' do
    log_in_as @moderator

    get edit_user_path(@user)
    # Assert there is no tag for user permissions.
    assert_select 'select[id=user_permissions]', count: 0

    # Try to change permissions
    patch user_path(@user), params: {
      user: {
        permissions: 'moderator'
      }
    }
    # Assert it failed.
    assert_not_equal 'moderator', @user.reload.permissions
  end

  test 'regular user should NOT be able to elevate permissions' do
    log_in_as @villain

    get edit_user_path(@user)
    # Assert there is no tag for user permissions.
    assert_select 'select[id=user_permissions]', count: 0

    # Try to change permissions
    patch user_path(@user), params: {
      user: {
        permissions: 'moderator'
      }
    }
    # Assert it failed.
    assert_not_equal 'moderator', @user.reload.permissions
  end
end
