require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = 'KM-Forum'
    @category = categories(:first)
    @admin = users(:admin)
  end

  test 'should get index' do
    get categories_url
    assert_response :success
    assert_select 'title', @base_title
    assert_template 'categories/index'
  end

  test 'should get show' do
    get category_url(@category)
    assert_response :success
    assert_select 'title', "#{@category.title} | #{@base_title}"
    assert_template 'categories/show'
  end

  test 'should get new' do
    log_in_as(@admin)
    get new_category_url
    assert_response :success
    assert_select 'title', "New category | #{@base_title}"
    assert_template 'categories/new'
  end

  test 'should get edit' do
    log_in_as(@admin)
    get edit_category_url(@category)
    assert_response :success
    assert_select 'title', "Edit category | #{@base_title}"
    assert_template 'categories/edit'
  end
end
