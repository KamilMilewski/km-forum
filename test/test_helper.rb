ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Those two lines are for minitest-reporters gem to work.
require 'minitest/reporters'
Minitest::Reporters.use!

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical
    # order.
    fixtures :all

    # We need ApplicationHelper methods in tests.
    include ApplicationHelper

    # Methods used by all tests:
    def logged_in?
      !session[:user_id].nil?
    end

    def log_in_as(user)
      session[:user_id] = user.id
    end
  end
end

# Helper methods for integration tests.
module ActionDispatch
  class IntegrationTest
    def log_in_as(user, password: nil, remember_me_checkbox: '0')
      # If password hasn't been specified then method checks if passed user
      # isn't one of the three generic users in fixtures: admin, moderator or
      # user. If not then generic password 'uuuuuu' is used.
      if password.nil?
        password = case user.email
                   when 'admin@admin.com'         then 'aaaaaa'
                   when 'moderator@moderator.com' then 'mmmmmm'
                   when 'user@user.com'           then 'uuuuuu'
                   else                                'uuuuuu'
                   end
      end

      # Finally try to log in given user.
      post login_path, params: { session: {
        email: user.email,
        password: password,
        remember_me_checkbox: remember_me_checkbox
      } }
    end

    def assert_access_denied_notice
      assert_redirected_to root_path
      follow_redirect!
      assert_flash_notices danger_count: 1
    end

    def assert_flash_notices(danger_count: 0,
                             success_count: 0,
                             info_count: 0,
                             warning_count: 0)
      assert_select 'div.alert-danger', count: danger_count
      assert_select 'div.alert-success', count: success_count
      assert_select 'div.alert-info', count: info_count
      assert_select 'div.alert-warning', count: warning_count
    end
  end
end
