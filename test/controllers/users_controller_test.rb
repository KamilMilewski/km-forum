require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get user index page" do
    get users_path
    assert_response :success
    assert_select "title", "User index | #{@base_title}"
  end
end
