require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new( name: "example user", email: "example@user.com",
                      password: "foobar", password_confirmation: "foobar",
                      permissions: "admin"
            )
  end

  test "valid user should be... valid" do
    assert @user.valid?, "Example user should pass validation."
  end



  #name validation tests

  test "name can't be blank" do
    @user.name = '  '
    assert_not @user.valid?,
        "User model validation shouldn't allow name attr. to be blank."
  end

  test "name can't be too long" do
    @user.name = 'a' * 26
    assert_not @user.valid?, "User model validation shouldn't accept name" +
    " longer than 25 chars."
  end



  #email validation tests

  test "email can't be blank" do
    @user.email = '  '
    assert_not @user.valid?,
        "User model validation shouldn't allow email attr. to be blank."
  end

  test "email can't be too long" do
    @user.email = 'a' * 244 + "@example.com"
    assert_not @user.valid?, "User model validation shouldn't accept email" +
    " longer than 255 chars."
  end

  test "email should be unique" do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?, "User model validation should accept" +
    " only unique emails."
  end

  test "email should be saved as lower-case" do
    mixed_case_email = "ExAmPle@mixedcase.email.com"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test "should accept valid emails" do
    valid_emails = %w[
      valid@email.com
      OtHeRvAlId@email.tv
      valid+email@format.es
      this-email-is-valid@also.gr.ru
    ]
    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "User model validation should accept" +
      " email: #{valid_email.inspect}"
    end
  end

  test "should reject invalid emails" do
    invalid_emails = %w[
      user@example,com
      user_at_foo.org
      user.name@example.
      foo@bar_baz.com
      foo@bar+baz.com
      first.last@foo..ru
    ]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "User model validation should reject" +
      " email: #{invalid_email.inspect}"
    end
  end

  #permissions validation tests

  test "permissions validation should accept valid permissions" do
    valid_nouns = %w[user moderator admin]
    valid_nouns.each do |noun|
      @user.permissions = noun
      assert @user.valid? "User model validation should accept one of the" +
      " three nouns: user moderator admin."
    end
  end

  test "permissions validation shouldn't accept invalid permissions" do
    invalid_nouns = %w[foo bar baz]
    invalid_nouns.each do |noun|
      @user.permissions = noun
      assert_not @user.valid?, "User model validation shouldn't accept" +
      " anything except user, moderator or admin."
    end
  end



  #password validation tests

  test "password can't be blank" do
    @user.password = ' ' * 6
    assert_not @user.valid?,
        "User model validation shouldn't allow password attr. to be blank."
  end

  test "password can't be too short" do
    #We should set both because otherwise @user.valid? will always false due to
    #password and password_confirmation not matching.
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?, "User model validation shouldn't accept" +
    " passwords shorter than 6 chars."
  end

  # test "password can't be too long" do
  #  This is already done by bcrypt gem validation
  # end
end
