require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:user)
  end

  test "user index page with will_paginate as an admin" do
    get login_path
    log_in_as(@admin, password: 'aaaaaa')
    get users_path
    assert_response :success
    assert_template 'users/index'

    assert_select "ul.pagination", count: 2

    @users = User.paginate(page: 1, per_page: 30)
    @users.each do |user|
      assert_select "a[href=?]", user_path(user)
      assert_select "a[href=?]", edit_user_path(user)
      if user != @admin #Current logged in admin sholdn't be abble to delete himself.
        # Check if there is a link issuing a delete action on users resource.
        assert_select "a[data-method=delete][href=?]", user_path(user), count: 1
      end
    end

  end

  test "regular user should not see delete links on users index page" do
    get login_path
    log_in_as(@user, password: 'uuuuuu')
    get users_path
    @users = User.paginate(page: 1, per_page: 30)
    @users.each do |user|
      # Check if there is a link issuing a delete action on users resource.
      assert_select "a[data-method=delete][href=?]", user_path(user), count: 0
    end
  end
end
