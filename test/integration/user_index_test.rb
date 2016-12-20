require 'test_helper'

class UserIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    @user = users(:user)

    @per_page = KmForum::USERS_PER_PAGE
  end

  test 'user index page with will_paginate, as an admin' do
    # Get to the login page and log in user.
    get login_path
    log_in_as(@admin)

    users = User.paginate(page: 1, per_page: @per_page)
    # We need one not activated user. Admin should see him on index page
    users.third.update_columns(activated: false, activated_at: nil)
    # Just to make sure we didn't 'unactivated' current logged in user.
    assert_not users.third == @user

    # Get to the user index page and assure correct template.
    get users_path
    assert_response :success
    assert_template 'users/index'
    # Assure there are two will_paginate controls on the page.
    assert_select 'ul.pagination', count: 1

    # Assure there is link to show, edit and delete actions for each user.
    users.each do |user|
      assert_select 'a[href=?]', user_path(user)
      # Current logged in admin sholdn't be abble to delete or edit himself.
      next if user.admin?
      assert_select 'a[data-method=delete][href=?]', user_path(user), count: 1
      # For current logged in user there will be actually two links to edit
      # profile. One in user list and one in site top navbar: "account
      # settings" In this test we are only interested in the one in user list,
      # thus addition of text: /edit/ in line below.
      assert_select 'a[href=?]', edit_user_path(user), count: 1
    end
  end

  test 'user index page with will_paginate, as an regular user' do
    get login_path
    log_in_as(@user)

    users = User.paginate(page: 1, per_page: @per_page)
    # We need one not activated user. Admin should see him on index page
    users.third.update_columns(activated: false, activated_at: nil)
    # Just to make sure we didn't 'unactivated' current logged in user.
    assert_not users.third == @user

    get users_path

    users.each do |user|
      # Check if there is a edit or delete link
      assert_select 'a[href=?]', edit_user_path(user), count: 0
      assert_select 'a[data-method=delete][href=?]', user_path(user), count: 0
    end
  end
end
