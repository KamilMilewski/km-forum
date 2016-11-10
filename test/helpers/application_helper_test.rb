require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper' do
    assert_equal full_title, 'KM-Forum'
    assert_equal full_title('About'), 'About | KM-Forum'
  end
end
