require 'test_helper'

class CategoryCreateTest < ActionDispatch::IntegrationTest
  def setup
    # Only admin can create categories.
    @admin = users(:admin)

    # Moderators and regular users can't create categories.
    @moderator = users(:moderator)
    @user = users(:user)
    @denied_users = [@moderator, @user]
  end

  test 'should allow admin enter new category page' do
    log_in_as(@admin)
    get new_category_path
    assert_template 'categories/new'
    assert_flash_notices
  end

  test 'should NOT allow non admin users enter new category page' do
    @denied_users.each do |user|
      log_in_as(user)

      get new_category_path

      assert_access_denied_notice
    end
  end

  test 'should NOT allow not logged in user enter new category page' do
    get new_category_path

    assert_friendly_forwarding_notice
  end

  test 'should allow admin create new category' do
    log_in_as(@admin)

    # Assure new category has been created.
    assert_difference 'Category.count', 1 do
      post categories_path, params: {
        category: {
          title: 'New valid category title',
          description: 'New valid category description'
        }
      }
    end

    # :FIXME assigns should not be used in but I don't have better idea.
    assert_redirected_to category_path(assigns(:category))
    follow_redirect!
    assert_flash_notices success: { count: 1 }
  end

  test 'should NOT allow to create category with invalid data' do
    log_in_as(@admin)

    # Assure no category has been created - using invalid data.
    assert_no_difference 'Category.count' do
      post categories_path, params: {
        category: {
          title: '',
          description: ''
        }
      }
    end

    assert_template 'categories/new'
    assert_flash_notices danger: { count: 1 }
  end

  test 'should NOT allow non admin users create category' do
    @denied_users.each do |user|
      log_in_as(user)

      # Assure no category has been created.
      assert_no_difference 'Category.count' do
        post categories_path, params: {
          category: {
            title: 'New valid category title',
            description: 'New valid category description'
          }
        }
      end

      assert_access_denied_notice
    end
  end

  test 'should NOT allow not logged in user create category' do
    # Assure no category has been created.
    assert_no_difference 'Category.count' do
      post categories_path, params: {
        category: {
          title: 'New valid category title',
          description: 'New valid category description'
        }
      }
    end

    assert_access_denied_notice
  end
end
