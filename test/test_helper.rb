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
      assert_flash_notices danger: { count: 1, text: 'Access denied.' }
    end

    # Asserts if proper flash notices has been displayed. If no params has been
    # passed then by default method asserts that there are no flash notices at
    # all.
    def assert_flash_notices(danger: { count: 0, text: nil },
                             success: { count: 0, text: nil },
                             info:    { count: 0, text: nil },
                             warning: { count: 0, text: nil })
      assert_select 'div.alert-danger',   count: danger[:count],
                                          text: /#{danger[:text]}/
      assert_select 'div.alert-success',  count: success[:count],
                                          text: /#{success[:text]}/
      assert_select 'div.alert-info',     count: info[:count],
                                          text: /#{info[:text]}/
      assert_select 'div.alert-warning',  count: warning[:count],
                                          text: /#{warning[:text]}/
    end
  end
end
