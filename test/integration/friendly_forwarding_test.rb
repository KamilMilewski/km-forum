require 'test_helper'

class FriendlyForwardingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:user)
  end

  # Those tests check if user will be forwarded to intended page after log in.

  test 'user edit friendly forwarding' do
    get edit_user_path(@user)
    assert_redirected_to login_path
    log_in_as(@user)
    assert_template 'users/edit'
  end
end
