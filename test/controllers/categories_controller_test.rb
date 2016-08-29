require 'test_helper'

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "KM-Forum"
  end

  test "should get index" do
    get categories_url
    assert_response :success
    assert_select "title", "#{@base_title}"
  end

  test "should get new" do
    get new_category_url
    assert_response :success
    assert_select "title", "New Category | #{@base_title}"
  end

end
