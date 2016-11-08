require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'account_activation' do
    user = users(:user)
    # activation_token is a virtual field,
    # so we couldn't handle it in fixture file.
    user.activation_token = User.new_token
    mail = UserMailer.account_activation(user)
    assert_equal 'KM-Forum account activation', mail.subject
    assert_equal [user.email],                  mail.to
    assert_equal ['km.web.smtp@gmail.com'],     mail.from
    assert_match user.name,                     mail.body.encoded
    assert_match user.activation_token,         mail.body.encoded
    # Assure that escaped user email is in an activation link as a parameter.
    assert_match CGI.escape(user.email),        mail.body.encoded
  end
end
