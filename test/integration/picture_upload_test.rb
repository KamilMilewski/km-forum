require 'test_helper'

class PictureUploadTest < ActionDispatch::IntegrationTest
  def setup
    # @user's topic
    @topic = topics(:third)
    @category = categories(:first)

    @user = users(:user)
    # To upload file, user has to be logged in.
    log_in_as(@user)
    @picture = fixture_file_upload('test/fixtures/kitten.png', 'image/png')
  end

  test 'should allow user upload picture during post creation' do
    assert_difference 'Post.count' do
      post topic_posts_path(@topic), params: {
        post: {
          content: 'some content',
          picture: @picture
        }
      }
    end
    # Assert there is a picture associated with post.
    assert assigns(:post).picture?
  end

  test 'should allow user delete picture during post edit' do
    post topic_posts_path(@topic), params: {
      post: {
        content: 'some content',
        picture: @picture
      }
    }

    # Assert there is a picture associated with post.
    @post = assigns(:post)
    assert @post.picture?

    patch post_path(@post), params: {
      post: {
        content: 'some content'
      },
      delete_picture: true
    }

    @post = assigns(:post)
    assert_not @post.picture?
  end

  test 'should allow user upload picture during topic creation' do
    assert_difference 'Topic.count' do
      post category_topics_path(@category), params: {
        topic: {
          title: 'some title',
          content: 'some content',
          picture: @picture
        }
      }
    end
    # assert there is a picture associated with a topic.
    assert assigns(:topic).picture?
  end

  test 'should allow user delete picture during topic edit' do
    post category_topics_path(@category), params: {
      topic: {
        title: 'some title',
        content: 'some content',
        picture: @picture
      }
    }

    # assert there is picture associated with a topic.
    @topic = assigns(:topic)
    assert @topic.picture?

    patch topic_path(@topic), params: {
      topic: {
        title: 'some title',
        content: 'some content'
      },
      delete_picture: true
    }

    @topic = assigns(:topic)
    assert_not @topic.picture?
  end
end
