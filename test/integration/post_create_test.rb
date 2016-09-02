require 'test_helper'

class PostCreateTest < ActionDispatch::IntegrationTest
  test 'valid post creation' do
		#Get to new category page and assure that correct template is used
		get new_topic_post_path topics(:one)
		assert_response :success
		assert_template 'posts/new'

		#Test if create category with valid data vill succeed
		assert_difference 'Post.count', 1 do
			post topic_posts_path(posts(:one)), params: {post: {
				content: "test description"
				}
			}
		end
		assert_response :redirect
		follow_redirect!
		assert_template 'topics/show'
		#check if success flash massage shows up
		assert_select 'div.alert-success'
	end

	test 'invalid post creation' do
		#Get to new category page and assure that correct template is used
		get new_topic_post_path topics(:one)
		assert_response :success
		assert_template 'posts/new'

		#Test if create category with valid data will fail
		assert_no_difference 'Post.count' do
			post topic_posts_path(posts(:one)), params: {post: {
				content: "	"
				}
			}
		end

		assert_template 'posts/new'
		#check if error flash massage shows up
		assert_select 'div.alert-danger'
	end
end
