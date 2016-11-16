require 'test_helper'

class CategoryEditTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
    # Just regular villain(user) who will try to perform action forbidden to him
    @villanous_user = users(:user_4)
    @category = categories(:first)

    # New valid values for category title and description.
    @new_category_title = 'New valid category title'
    @new_category_description = 'New valid category description'
  end

  test 'visit category edit page' do
    # Only admin  can edit category.
    log_in_as(@admin)
    assert_redirected_to root_path
    follow_redirect!
    get edit_category_path(@category)
    assert_template 'categories/edit'
    assert_flash_notices
  end

  test 'successfull category edit as an admin' do
    # Only admin can edit category.
    log_in_as(@admin)
    get edit_category_path(@category)

    assert_category_update
    assert_redirected_to root_path
    follow_redirect!
    assert_flash_notices success: { count: 1 }
  end

  test 'unsuccessful category edit' do
    # Only admin can edit category.
    log_in_as(@admin)
    get edit_category_path(@category)

    # New invalid value for category title.
    @new_category_title = ''

    assert_category_update(is_not: true)
    assert_flash_notices danger: { count: 1 }
    assert_template 'categories/edit'
  end

  test 'sinister attempt to edit category by regular user' do
    # Log in as regular user. He can't edit categories.
    log_in_as(@villanous_user)

    # First he tries to enter category edit page.
    get edit_category_path(@category)
    assert_redirected_to root_path

    # He tries direct patch request.
    assert_category_update(is_not: true)
    assert_access_denied_notice
  end

  test 'sinister attempt to edit category by non logged in villain' do
    # First he tries to enter category edit page.
    get edit_category_path(@category)
    assert_redirected_to login_path

    # He tries direct patch request.
    assert_category_update(is_not: true)
    assert_access_denied_notice
  end

  # helper method for updating category record in db. It also checks if record
  # update succeeded. By default success category record update is verified.
  def assert_category_update(is_not: false)
    # Request to edit given category record in db.
    patch category_path(@category), params: {
      category: {
        title: @new_category_title,
        description: @new_category_description
      }
    }

    @category.reload
    if is_not
      assert_not_equal @new_category_title, @category.title
      assert_not_equal @new_category_description, @category.description
    else
      assert_equal @new_category_title, @category.title
      assert_equal @new_category_description, @category.description
    end
  end
end
