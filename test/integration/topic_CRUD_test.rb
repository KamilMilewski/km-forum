require 'test_helper'

class TopicCRUDTest <ActionDispatch::IntegrationTest
	test 'topic_CRUD' do
								 
		#Get to new topic page and assure that correct template is used		
		get new_category_topic_path(categories(:one))
		assert_response :success
		assert_template 'topics/new'
		#Create topic
		post category_topics_path, 
			params: {topic: {title: "test category", 
							 content: "test description",
							 category_id: categories(:one).id,
							 user_id: users(:one).id
							 }
					}
		assert_response :redirect
		follow_redirect!
		assert_response :success
		assert_template 'topics/show'


		#Get to edit topic page and assure that correct template is used	
		get edit_category_topic_path(categories(:one))
		assert_response :success
		assert_template 'topics/edit'

		#to be continued...
	end
end