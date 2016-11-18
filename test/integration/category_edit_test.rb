require 'test_helper'

class CategoryEditTest < ActionDispatch::IntegrationTest
  def setup
    # Only admins can edit categories.
    @admin = users(:admin)

    # Moderators and regular users can't enter category edit page.
    @moderator = users(:moderator)
    @user = users(:user)
    @denied_users = [@moderator, @user]
    # A villain(regular user) who will try to perform action forbidden to him.
    @villain = users(:user_4)

    @category = categories(:first)

    # New valid values for category title and description.
    @new_title = 'New valid category title'
    @new_description = 'New valid category description'
  end

  test 'should allow admin to enter category edit page' do
    log_in_as(@admin)

    get edit_category_path(@category)
    assert_template 'categories/edit'
    assert_flash_notices
  end

  test 'should NOT allow non admin users enter category edit page' do
    @denied_users.each do |user|
      log_in_as(user)

      get edit_category_path(@category)
      assert_access_denied_notice
    end
  end

  test 'should NOT allow not logged in user enter category edit page' do
    get edit_category_path(@category)
    assert_friendly_forwarding_notice
  end

  test 'should allow admin to update category' do
    log_in_as(@admin)

    patch category_path(@category), params: {
      category: {
        title: @new_title,
        description: @new_description
      }
    }

    # Assert category has been updated.
    @category.reload
    assert_equal @new_title, @category.title
    assert_equal @new_description, @category.description

    assert_redirected_to root_path
    follow_redirect!
    assert_flash_notices success: { count: 1 }
  end

  test 'should NOT allow to update category with invalid data' do
    # Invalid data for category.
    @new_title = ''
    @new_content = ''

    log_in_as(@admin)

    patch category_path(@category), params: {
      category: {
        title: @new_title,
        description: @new_description
      }
    }

    # Assert category has NOT been updated.
    @category.reload
    assert_not_equal @new_title, @category.title
    assert_not_equal @new_description, @category.description

    assert_flash_notices danger: { count: 1 }
    assert_template 'categories/edit'
  end

  test 'should NOT allow users other than admin update category' do
    @denied_users.each do |user|
      log_in_as(user)

      patch category_path(@category), params: {
        category: {
          title: @new_title,
          description: @new_description
        }
      }

      # Assert category has NOT been updated.
      @category.reload
      assert_not_equal @new_title, @category.title
      assert_not_equal @new_description, @category.description

      assert_access_denied_notice
    end
  end

  test 'should NOT allow non logged in user update category' do
    patch category_path(@category), params: {
      category: {
        title: @new_title,
        description: @new_description
      }
    }

    # Assert category has NOT been updated.
    @category.reload
    assert_not_equal @new_title, @category.title
    assert_not_equal @new_description, @category.description

    assert_access_denied_notice
  end
end
