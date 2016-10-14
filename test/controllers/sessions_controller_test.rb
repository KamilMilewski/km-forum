require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "KM-Forum"
  end

  test "should get new" do
    get sessions_new_url
    assert_response :success
    assert_select "title", "Log in | #{@base_title}"
    assert_template "sessions/new"
  end
end
