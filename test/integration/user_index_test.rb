require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:user)
  end

  test 'user index page with will_paginate, as an admin' do
    # Get to the login page and log in user.
    get login_path
    log_in_as(@admin, password: 'aaaaaa')
    # Get to the user index page and assure correct template.
    get users_path
    assert_response :success
    assert_template 'users/index'
    # Assure there are two will_paginate controls on the page.
    assert_select 'ul.pagination', count: 2

    @users = User.paginate(page: 1, per_page: 10)
    # Assure there is link to show, edit and delete actions for each user.
    @users.each do |user|
      assert_select 'a[href=?]', user_path(user)
      # For current logged in user there will be actually two links to edit
      # profile. One in user list and one in site top navbar: "account settings"
      # In this test we are only interested in the one in user list thus
      # addition of text: /edit/ in line below.
      assert_select 'a[href=?]', edit_user_path(user), text: 'edit', count: 1
      # Current logged in admin sholdn't be abble to delete himself.
      if user != @admin
        assert_select 'a[data-method=delete][href=?]', user_path(user), count: 1
      end
    end
  end

  test 'regular user should not see delete links on users index page' do
    get login_path
    log_in_as(@user, password: 'uuuuuu')
    get users_path
    users = User.paginate(page: 1, per_page: 30)
    users.each do |user|
      # Check if there is a link issuing a delete action on users resource.
      assert_select 'a[data-method=delete][href=?]', user_path(user), count: 0
    end
  end
end
