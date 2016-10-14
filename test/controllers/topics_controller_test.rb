require 'test_helper'

class TopicsControllerTest < ActionDispatch::IntegrationTest
	def setup
		@base_title = "KM-Forum"
	end
	
	test "should get show" do
		get topic_url(topics(:one))
		assert_response :success
		assert_select "title", "#{topics(:one).title} | #{@base_title}"
		assert_template "topics/show"
	end

	test "should get new" do
		get new_category_topic_url(categories(:one))
		assert_response :success
		assert_select "title", "New topic | #{@base_title}"
		assert_template "topics/new"
	end

	test "should get edit" do
		get edit_topic_url(topics(:one))
		assert_response :success
		assert_select "title", "Edit topic | #{@base_title}"
		assert_template "topics/edit"
	end
end
