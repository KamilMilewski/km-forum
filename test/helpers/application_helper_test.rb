require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full title helper' do
    assert_equal full_title, 'KMForum'
    assert_equal full_title('About'), 'About | KMForum'
  end
end
