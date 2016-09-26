require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest
  test "user index page with will_paginate" do
    get users_path
    assert_response :success
    assert_template 'users/index'

    assert_select "ul.pagination", count: 2

    @users = User.paginate(page: 1, per_page: 30)
    @users.each do |user|
      assert_select "a[href=?]", user_path(user)
      assert_select "a[href=?]", edit_user_path(user)
      assert_select "a[href=?]", user_path(user), method: :delete
    end

  end
end
