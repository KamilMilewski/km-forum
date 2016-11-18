require 'test_helper'

class UserDeleteTest < ActionDispatch::IntegrationTest
  def setup
    # Admins can delete all users. Moderators can delete all users excluded
    # admin. :TODO Users for now can't delete their account.
    @admin = users(:admin)
    @moderator = users(:moderator)
    @user = users(:user)

    # A villain(regular user) who will try to perform action forbidden to him.
    @villain = users(:user_4)
  end

  test 'should allow admin delete user' do
    delete_user_by(@admin)
  end

  test 'should allow moderator delete user' do
    delete_user_by(@moderator)
  end

  test 'should allow user delete his own account' do
    # :TODO implement test and app funcionality.
  end

  # Helper method applicable to successfull user delete tests.
  def delete_user_by(user)
    log_in_as(user)

    # Assert exactly one user has been deleted.
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end

    assert_redirected_to users_path
    follow_redirect!
    assert_flash_notices success: { count: 1 }
  end

  test 'should NOT allow moderator delete admin\'s account' do
    log_in_as(@moderator)

    # Assert no users has been deleted.
    assert_no_difference 'User.count' do
      delete user_path(@admin)
    end

    assert_access_denied_notice
  end

  test 'should NOT allow user delete another user' do
    log_in_as(@villain)

    # Assert no users has been deleted.
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end

    assert_access_denied_notice
  end

  test 'should NOT allow NOT logged in user delete user' do
    # Assert no users has been deleted.
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end

    assert_access_denied_notice
  end
end
