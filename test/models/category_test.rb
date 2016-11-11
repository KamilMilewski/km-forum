require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def setup
    @category = categories(:first)
  end

  test 'valid category should be... valid' do
    assert @category.valid?,
           'Example category from fixture file should pass validation.'
  end

  test "title can't be blank" do
    @category.title = ' '
    assert_not @category.valid?,
               "Category model validaton shouldn't allow title attr. to be " \
               'blank.'
  end

  test "title cant't be too long" do
    @category.title = 'a' * 256
    assert_not @category.valid?,
               "Category model validation shouldn't allow title attr. to be " \
               'longer than 255 chars'
  end
end
