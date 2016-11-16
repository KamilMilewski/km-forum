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
    # check if success flash massage shows up
    assert_select 'div.alert-success'
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
    # check if error flash massage shows up
    assert_select 'div.alert-danger'
  end
end
