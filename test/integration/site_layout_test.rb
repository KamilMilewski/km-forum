require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'test_layout_links' do
    # Get to main page and assure that correct template is used
    get root_path
    assert_template 'categories/index'

    # Assure that there are all three links on navbar
    assert_select 'a[href=?]', root_path, count: 1
    assert_select 'a[href=?]', contact_path, count: 1
    assert_select 'a[href=?]', about_path, count: 1

    # Get to contact page and assure the title is correct
    get contact_path
    assert_select 'title', full_title('Contact')

    # Get to about page and assure the title is correct
    get about_path
    assert_select 'title', full_title('About')
  end
end
