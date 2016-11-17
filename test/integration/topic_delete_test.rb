require 'test_helper'

class TopicDeleteTest < ActionDispatch::IntegrationTest
  def setup
    # Only admin should be able to delete category.
    @admin = users(:admin)
    # Just regular villain(user) who will try to perform action forbidden to him
    @villain = users(:user_4)
    @user = users(:user)
    @category = categories(:first)
    # @topic belongs to @category, created by user
    @topic = topics(:third)
  end

  test 'successful topic delete from topics index page, as an admin' do
    log_in_as(@admin)
    get category_path(@category)

    assert_difference 'Topic.count', -1 do
      delete topic_path(@topic)
    end

    # Aka topics index
    assert_redirected_to @category
    follow_redirect!
    assert_flash_notices success: { count: 1 }
  end

  test 'user should be able to delete his topic' do
    log_in_as(@user)
    get category_path(@category)

    assert_difference 'Topic.count', -1 do
      delete topic_path(@topic)
    end

    # Aka topics index
    assert_redirected_to @category
    follow_redirect!
    assert_flash_notices success: { count: 1 }
  end

  # :FIXME: FOR GODS SAKE !!!
  test 'villanous attempt to delete topic by non admin user who do not own' \
       ' given topic should fail' do
    # Log in as non admin user.
    log_in_as(@villain)
    get category_path(@category)

    assert_no_difference 'Topic.count' do
      delete topic_path(@topic)
    end
    assert_redirected_to root_path
  end

  test 'villanous attempt to delete topic by non logged in user should' \
       'fail' do
    get category_path(@category)

    assert_no_difference 'Topic.count' do
      delete topic_path(@topic)
    end
    assert_redirected_to root_path
  end
end
