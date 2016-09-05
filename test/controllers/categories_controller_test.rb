require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest

  test "should get index" do
    get categories_url
    assert_response :success
    assert_select "title", "#{@base_title}"
    assert_template "categories/index"
  end

  test "should get show" do
    get category_url(categories(:one))
    assert_response :success
    assert_select "title", "#{categories(:one).title} | #{@base_title}"
    assert_template 'categories/show'
  end

  test "should get new" do
    get new_category_url
    assert_response :success
    assert_select "title", "New category | #{@base_title}"
    assert_template 'categories/new'
  end

  test "should get edit" do
    get edit_category_url(categories(:one))
    assert_response :success
    assert_select "title", "Edit category | #{@base_title}"
    assert_template 'categories/edit'
  end
end
