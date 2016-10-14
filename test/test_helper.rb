ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Those two lines are for minitest-reporters gem to work.
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # We need ApplicationHelper methods in tests.
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...
  def is_logged_in?
    !session[:user_id].nil?
  end

  def log_in_as(user)
    session[:user_id] = user.id
  end
end

# Helper methods for integration tests.
class ActionDispatch::IntegrationTest
  def log_in_as(user, password: 'password', remember_me_checkbox: '1')
    # Log in as particular user.
    post login_path, params: { session: {
        email: user.email,
        password: password,
        remember_me_checkbox: remember_me_checkbox
      }
    }
  end
end
