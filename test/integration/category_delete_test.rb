require 'test_helper'

class CategoryDeleteTest < ActionDispatch::IntegrationTest
  def setup
    # Only admin should be able to delete category.
    @admin = users(:admin)
    # Just regular villain(user) who will try to perform action forbidden to him
    @villanous_user = users(:user_4)
    @category = categories(:first)
  end

  test 'successful category delete from categories index page' do
    log_in_as(@admin)
    get root_path

    assert_difference 'Category.count', -1 do
      delete category_path(@category)
    end

    assert_redirected_to root_path
    follow_redirect!
    assert_flash_notices success: { count: 1 }
  end

  test 'villanous attempt to delete category by non admin user should fail' do
    # Log in as non admin user. He shouldn't be able to delete categories.
    log_in_as(@villanous_user)
    get root_path

    assert_no_difference 'Category.count' do
      delete category_path(@category)
    end
    assert_redirected_to root_path
  end

  test 'villanous attempt to delete category by non logged in user should' \
       'fail' do
    get root_path

    assert_no_difference 'Category.count' do
      delete category_path(@category)
    end
    assert_redirected_to root_path
  end
end
