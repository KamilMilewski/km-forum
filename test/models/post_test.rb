require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @post = posts(:one)
  end

  test "valid post should be... valid" do
    assert @post.valid?,
          "Example post from fixture file should pass validation."
  end

  test "content can't be blank" do
    @post.content = ' '
    assert_not @post.valid?,
              "Post model validaton shouldn't allow content attr. to be blank."
  end

end
