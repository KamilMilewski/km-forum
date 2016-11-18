require 'test_helper'

class CategoryDeleteTest < ActionDispatch::IntegrationTest
  def setup
    # Only admin can delete categories.
    @admin = users(:admin)

    # A villain(regular user) who will try to perform action forbidden to him.
    @villain = users(:user_4)

    @category = categories(:first)
  end

  test 'should allow admin delete category' do
    log_in_as(@admin)
    assert_redirected_to root_path
    follow_redirect!

    # Assert exactly one category has been deleted.
    assert_difference 'Category.count', -1 do
      delete category_path(@category)
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_flash_notices success: { count: 1 }
  end

  test 'should NOT allow non admin users delete category' do
    # Log in as non admin user. He shouldn't be able to delete categories.
    log_in_as(@villain)
    assert_redirected_to root_path
    follow_redirect!

    assert_no_difference 'Category.count' do
      delete category_path(@category)
    end

    assert_access_denied_notice
  end

  test 'should NOT allow non logged in user delete category' do
    get root_path

    assert_no_difference 'Category.count' do
      delete category_path(@category)
    end

    assert_access_denied_notice
  end
end
