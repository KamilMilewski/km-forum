ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

#Those two lines are for minitest-reporters gem to work
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  #We need full_title helper method in our test so we have to include app helper
  include ApplicationHelper

  # Add more helper methods to be used by all tests here...
  def setup
    @base_title = "KM-Forum"
  end
end
