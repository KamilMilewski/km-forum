require 'test_helper'

class CategoriesIndexTest < ActionDispatch::IntegrationTest
  def setup
    # Only admin should be able to see category edit & delete links.
    @admin = users(:admin)
    @moderator = users(:moderator)
    @user = users(:user)

    # All fixture categories.
    @categories = [categories(:first), categories(:second), categories(:third)]

    # There is no pagination on this page.
  end

  test 'should access categories index page, as an admin' do
    log_in_as(@admin)

    assert_basic_layout

    @categories.each do |category|
      # Assert there is category title and description.
      assert_category_body_for(category)
      # Assert there is link to show, edit & delete actions for each category.
      # There are two links that match categories_path(category). One for show
      # action and one for delete.
      assert_select 'a[href=?]', category_path(category), count: 2
      assert_edit_delete_links_for(category, links_count: 1)
    end
  end

  test 'should access categories index page, as an moderator' do
    log_in_as(@moderator)

    assert_basic_layout
    assert_categories_index_for_non_admin
  end

  test 'should access categories index page, as an user' do
    log_in_as(@user)

    assert_basic_layout
    assert_categories_index_for_non_admin
  end

  test 'should access categories index page, as an not logged in user' do
    assert_basic_layout
    assert_categories_index_for_non_admin
  end

  # Helper methods speciffic only to this file:
  def assert_basic_layout
    # root_path is actually categories index.
    get root_path
    assert_template 'categories/index'
    # Assert there is no flash messages.
    assert_flash_notices
  end

  def assert_categories_index_for_non_admin
    @categories.each do |category|
      # Assert there is category title and description.
      assert_category_body_for(category)

      # Assert there is link to show action for each category.
      assert_select 'a[href=?]', category_path(category), count: 1
      # There should be no links to category edit or delete actions.
      assert_edit_delete_links_for(category, links_count: 0)
    end
  end

  # Assert there is category title and description.
  def assert_category_body_for(category, present: true)
    if present
      assert_match      CGI.escapeHTML(category.title),        response.body
      assert_match      CGI.escapeHTML(category.description),  response.body
    else
      assert_no_match   CGI.escapeHTML(category.title),        response.body
      assert_no_match   CGI.escapeHTML(category.description),  response.body
    end
  end
end
