require 'test_helper'

class TopicCreateTest <ActionDispatch::IntegrationTest
	def setup
		@user = users(:user)
	end

	test 'valid topic creation' do
		log_in_as(@user)
		#Get to new category page and assure that correct template is used
		get new_category_topic_path categories(:one)
		assert_response :success
		assert_template 'topics/new'
		#Test if create category with valid data vill succeed
		assert_difference 'Topic.count', 1 do
			post category_topics_path(categories(:one)), params: {topic: {
				title: "test category",
				content: "test description",
				user_id: @user.id
				}
			}
		end
		assert_response :redirect
		follow_redirect!
		assert_template 'topics/show'
		#check if success flash massage shows up
		assert_select 'div.alert-success'
	end

	test 'invalid topic creation' do
		log_in_as(@user)
		#Get to new category page and assure that correct template is used
		get new_category_topic_path categories(:one)
		assert_response :success
		assert_template 'topics/new'
		#Test if create category with valid data will fail
		assert_no_difference 'Topic.count' do
			post category_topics_path(categories(:one)), params: {topic: {
				title: "	",
				content: "	"
				}
			}
		end
		assert_template 'topics/new'
		#check if error flash massage shows up
		assert_select 'div.alert-danger'
	end
end
