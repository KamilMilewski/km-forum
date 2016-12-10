require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def setup
    @topic = topics(:first)
  end

  test 'valid topic should be valid' do
    assert @topic.valid?, 'Example fixture topic should pass validation.'
  end

  test "title can't be blank" do
    @topic.title = ' '
    assert_not @topic.valid?,
               "Topic model validation shouldn't allow title attr. to be blank."
  end

  test "title cant't be too long" do
    @topic.title = 'a' * 256
    assert_not @topic.valid?,
               "Topic model validation shouldn't allow title attr. to be longer
                 than 255 chars"
  end

  test "content can't be blank" do
    @topic.content = '  '
    assert_not @topic.valid?,
               "Topic model validation shouldn't allow content attr. to be " \
               'blank.'
  end

  test 'should assign last_activity upon topic create' do
    category = categories(:first)
    user = users(:user)
    topic = category.topics.create(title: 'some title',
                                   content: 'some content',
                                   user_id: user.id,
                                   category_id: category.id)
    assert_not_nil topic.reload.last_activity
  end
end
