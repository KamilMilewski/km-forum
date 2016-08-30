require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
	test "should get show" do
		get topic_url(topics(:one))
		assert_response :success
		assert_select "title", "#{topics(:one).title} | #{@base_title}"
		assert_template "topics/show"
	end
	
	test "should get new" do
		get new_category_topic_url(categories(:one))
		assert_response :success
		assert_select "title", "New Topic | #{@base_title}"
		assert_template "topics/new"
	end

	test "should get edit" do
		get edit_topic_url(topics(:one))
		assert_response :success
		assert_select "title", "Edit Topic | #{@base_title}"
		assert_template "topics/edit"
	end
end
