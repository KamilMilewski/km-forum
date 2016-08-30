require 'test_helper'

class CategoryCRUDTest <ActionDispatch::IntegrationTest
	test 'category_CRUD' do
		#Get to new category page and assure that correct template is used		
		get new_category_path
		assert_response :success
		assert_template 'categories/new'

		#Create category
		post categories_path, 
			params: {category: {title: "test category", description: "test description"}}
		assert_response :redirect
		follow_redirect!
		assert_response :success
		assert_template 'categories/show'

		#Editing category
		get edit_category_path categories(:one)
		assert_response :success
		assert_template 'categories/edit'

		#to be continued...
	end
end