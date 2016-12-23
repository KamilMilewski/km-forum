require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'account_activation' do
    user = users(:user)
    # activation_token is a virtual field,
    # so we couldn't handle it in fixture file.
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal 'KMForum account activation', mail.subject
    assert_equal [user.email],                  mail.to
    assert_equal ['kmf.kmf@o2.pl'],             mail.from
    assert_match user.name,                     mail.body.encoded
    assert_match user.activation_token,         mail.body.encoded
    # Assure that escaped user email is in an activation link as a parameter.
    assert_match CGI.escape(user.email),        mail.body.encoded
  end

  test 'password reset' do
    user = users(:user)
    # password_reset_token is virtual field,
    # so we couldn't handle it in fixture file.
    user.password_reset_token = User.new_token
    mail = UserMailer.password_reset(user)
    assert_equal 'KMForum password reset', mail.subject
    assert_equal [user.email],                  mail.to
    assert_equal ['kmf.kmf@o2.pl'],             mail.from
    assert_match user.name,                     mail.body.encoded
    assert_match user.password_reset_token,     mail.body.encoded
    # Assure that escaped user email is in an activation link as a parameter.
    assert_match CGI.escape(user.email),        mail.body.encoded
  end
end
