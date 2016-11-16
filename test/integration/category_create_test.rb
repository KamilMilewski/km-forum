require 'test_helper'

class CategoryCreateTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:admin)
  end

  test 'valid category creation' do
    log_in_as(@admin)
    # Get to new category page and assure that correct template is used
    get new_category_path
    assert_response :success
    assert_template 'categories/new'

    # Test if create category with valid data vill succeed
    assert_difference 'Category.count', 1 do
      post categories_path, params: { category: {
        title: 'test category', description: 'test description'
      } }
    end
    assert_response :redirect
    follow_redirect!
    assert_template 'categories/show'
    assert_flash_notices success: { count: 1 }
  end

  test 'invalid category creation' do
    log_in_as(@admin)
    # Get to new category page and assure that correct template is used
    get new_category_path
    assert_response :success
    assert_template 'categories/new'

    # Test if create category with valid data will fail
    assert_no_difference 'Category.count' do
      post categories_path, params: { category: {
        title: "\t", description: 'test description'
      } }
    end

    assert_template 'categories/new'
    assert_flash_notices danger: { count: 1 }
  end
end
