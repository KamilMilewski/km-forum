require 'test_helper'

class PostsControllerTest < ActionDispatch::IntegrationTest
	test "should get new" do
		get new_topic_post_url(topics(:one))
		assert_response :success
		assert_select "title", "New Post | #{@base_title}"
		assert_template "posts/new"
	end

	test "should get edit" do
		get edit_post_url(posts(:one))
		assert_response :success
		assert_select "title", "Edit Post | #{@base_title}"
		assert_template "posts/edit"
	end
end
