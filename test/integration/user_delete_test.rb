require 'test_helper'

class UserDeleteTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    # This user is unfortunate enough to be victim of other's users villanous
    # deeds.
    @unfortunate_user = users(:user)
    # Just regular villain(user) who will try to perform action forbidden to him
    @villanous_user = users(:user_4)
  end

  test 'successful user delete from users index page' do
    # Log in as admin. Only he can delete users.
    log_in_as(@admin)
    # Get to user index page.
    get users_path
    assert_template 'users/index'

    assert_difference 'User.count', -1 do
      delete user_path(@unfortunate_user)
    end

    assert_redirected_to users_path
    follow_redirect!
    assert_select 'div.alert-success'
  end

  test 'villanous attempt to delete user by non admin user should fail' do
    # Log in as non admin user. He should not be able to delete users.
    log_in_as(@villanous_user)
    get users_path
    assert_template 'users/index'

    assert_no_difference 'User.count' do
      delete user_path(@unfortunate_user)
    end
    assert_redirected_to root_path
  end

  test 'sinister attempt to delete user by non logged in villain should fail' do
    assert_no_difference 'User.count' do
      delete user_path(@unfortunate_user)
    end
    assert_redirected_to root_path
  end
end
