require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    # We can't use fixture data here because of user virtual fields: password
    # and password_confirmation. Since we can't populate those virtual fields in
    # fixture file - every record would be invalid.
    @valid_user = User.new(
      name: 'valid user name',
      email: 'valid@email.com',
      permissions: 'user',
      password: 'valid password',
      password_confirmation: 'valid password'
    )

    # User who has some posts and topics.
    @user = users(:user)
  end

  test 'valid user should be valid' do
    assert @valid_user.valid?, 'Example fixture user should pass validation.'
  end

  # Name validation test.
  test "name can't be blank" do
    @valid_user.name = '  '
    assert_not @valid_user.valid?,
               "User model validation shouldn't allow name attr. to be blank."
  end

  # Name validation test.
  test "name can't be too long" do
    @valid_user.name = 'a' * 26
    assert_not @valid_user.valid?, "User model validation shouldn't accept " \
                                   'name longer than 25 chars.'
  end

  # Email validation test.
  test "email can't be blank" do
    @valid_user.email = '  '
    assert_not @valid_user.valid?,
               "User model validation shouldn't allow email attr. to be blank."
  end

  # Email validation test.
  test "email can't be too long" do
    @valid_user.email = 'a' * 244 + '@example.com'
    assert_not @valid_user.valid?, "User model validation shouldn't accept " \
                                   'email longer than 255 chars.'
  end

  # Email validation test.
  test 'email should be unique' do
    duplicate_user = @valid_user.dup
    duplicate_user.email = @valid_user.email.upcase
    @valid_user.save
    assert_not duplicate_user.valid?, 'User model validation should accept ' \
                                      'only unique emails.'
  end

  # Email validation test.
  test 'email should be saved as lower-case' do
    mixed_case_email = @valid_user.email.upcase
    @valid_user.email = mixed_case_email
    @valid_user.save
    assert_equal mixed_case_email.downcase, @valid_user.reload.email
  end

  # Email validation test.
  test 'should accept valid emails' do
    valid_emails = %w(
      valid@email.com
      OtHeRvAlId@email.tv
      valid+email@format.es
      this-email-is-valid@also.gr.ru
    )
    valid_emails.each do |valid_email|
      @valid_user.email = valid_email
      assert @valid_user.valid?, 'User model validation should accept ' \
                                 "email: #{valid_email.inspect}"
    end
  end

  # Email validation test.
  test 'should reject invalid emails' do
    invalid_emails = %w(
      user@example,com
      user_at_foo.org
      user.name@example.
      foo@bar_baz.com
      foo@bar+baz.com
      first.last@foo..ru
    )
    invalid_emails.each do |invalid_email|
      @valid_user.email = invalid_email
      assert_not @valid_user.valid?, 'User model validation should reject ' \
                                     "email: #{invalid_email.inspect}"
    end
  end

  # Permissions validation test.
  test 'permissions validation should accept valid permissions' do
    valid_nouns = %w(admin moderator user)
    valid_nouns.each do |noun|
      @valid_user.permissions = noun
      assert @valid_user.valid? 'User model validation should accept one of ' \
                                'the three nouns: admin moderator user.'
    end
  end

  # Permissions validation test.
  test "permissions validation shouldn't accept invalid permissions" do
    invalid_nouns = %w(foo bar baz)
    invalid_nouns.each do |noun|
      @valid_user.permissions = noun
      assert_not @valid_user.valid?, "User model validation shouldn't accept " \
                                     'anything except user, moderator or ' \
                                     'admin.'
    end
  end

  # Password validation test.
  test "password can't be blank" do
    @valid_user.password = ' ' * 6
    assert_not @valid_user.valid?,
               "User model validation shouldn't allow password attr. to be " \
               'blank.'
  end

  # Password validation test.
  test "password can't be too short" do
    # We should set both because otherwise @valid_user.valid? will always be
    # false due to password and password_confirmation not matching.
    @valid_user.password = @valid_user.password_confirmation = 'a' * 5
    assert_not @valid_user.valid?, "User model validation shouldn't accept " \
                                   'passwords shorter than 6 chars.'
  end

  test 'authenticated? should return false for a user with nil digest' do
    assert_not @valid_user.authenticated?(:remember, '')
  end

  test 'user.recent_post should return his newest post' do
    topic = topics(:first)
    post = topic.posts.create!(content: 'some content', user_id: @user.id)
    assert_equal post, @user.recent_post
  end

  test 'user.recent_topic should return his newest topic' do
    category = categories(:first)
    topic = category.topics.create!(title: 'some title',
                                    content: 'some content',
                                    user_id: @user.id)
    assert_equal topic, @user.recent_topic
  end

  test 'user.recent_activity should return his newest activity' do
    # For post
    topic = topics(:first)
    post = topic.posts.create!(content: 'some content', user_id: @user.id)
    assert_equal post, @user.recent_activity
    # For topic
    category = categories(:first)
    topic = category.topics.create!(title: 'some title',
                                    content: 'some content',
                                    user_id: @user.id)
    assert_equal topic, @user.recent_activity
  end

  test 'user.recent_activities should return X recent activities' do
    topic = topics(:first)
    category = categories(:first)
    # Create five items.
    item4 = topic.posts.create!(content: 'some content 1', user_id: @user.id)
    item3 = category.topics.create!(title: 'some title',
                                    content: 'some content',
                                    user_id: @user.id)
    item2 = topic.posts.create!(content: 'some content 2', user_id: @user.id)
    item1 = topic.posts.create!(content: 'some content 3', user_id: @user.id)
    item0 = category.topics.create!(title: 'some title 2',
                                    content: 'some content 2',
                                    user_id: @user.id)

    recent_activities = @user.recent_activities(count: 5)
    assert_equal recent_activities[0], item0
    assert_equal recent_activities[1], item1
    assert_equal recent_activities[2], item2
    assert_equal recent_activities[3], item3
    assert_equal recent_activities[4], item4
  end
end
