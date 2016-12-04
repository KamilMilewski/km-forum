require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
    @password = 'uuuuuu'
    @user = User.new(name: 'user', email: 'user@reset.com',
                     permissions: 'user', password: @password,
                     password_confirmation: @password, activated: 'true')
    @user.save
    ActionMailer::Base.deliveries.clear
  end

  test 'should allow user visit password reset request form' do
    get new_password_reset_path
    assert_new_form_layout
    assert_flash_notices
  end

  test 'should send password reset email for existing user email' do
    post password_resets_path, params: {
      password_reset: {
        email: @user.email
      }
    }
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_redirected_to root_path
    follow_redirect!
    assert_flash_notices info: { count: 1 }
  end

  test 'should NOT send password reset email for not-existing user email' do
    post password_resets_path, params: {
      password_reset: {
        email: 'no such email'
      }
    }
    assert_equal 0, ActionMailer::Base.deliveries.size
    assert_new_form_layout
    assert_flash_notices danger: { count: 1 }
  end

  test 'should NOT send password reset email for not-activated user' do
    @user.update_attribute(:activated, false)
    post password_resets_path, params: {
      password_reset: {
        email: @user.email
      }
    }
    assert_equal 0, ActionMailer::Base.deliveries.size
    assert_redirected_to root_path
    follow_redirect!
    assert_flash_notices danger: { count: 1 }
  end

  test 'should allow user who sent password reset email visit change password' \
       ' page' do
    # controller: password_resets, action: edit.
    # Method below also creates password_reset token and digest.
    @user.send_password_reset_email
    get edit_password_reset_path(@user.password_reset_token, email: @user.email)
    assert_edit_form_layout
  end

  test 'should NOT allow visit user change password page when ' \
       'password_reset_token is incorrect' do
    @user.send_password_reset_email
    # User.new_token will be obviously wrong token.
    get edit_password_reset_path(User.new_token, email: @user.email)
    assert_redirected_to root_path
    follow_redirect!
    assert_flash_notices danger: { count: 1 }
  end

  test 'should NOT allow visit user change password page when ' \
       'password_reset_token expired' do
    @user.send_password_reset_email
    # Lets simulate password reset request has been sent long time ago...
    @user.update_attribute(:sent_reset_at, 5.hours.ago)
    get edit_password_reset_path(@user.password_reset_token, email: @user.email)
    assert_redirected_to root_path
    follow_redirect!
    assert_flash_notices danger: { count: 1 }
  end

  test 'should allow user change password after sending password reset email' do
    new_password = 'foobar'
    # Method below also creates password_reset token and digest.
    @user.send_password_reset_email
    patch password_reset_path(@user.password_reset_token), params: {
      user: {
        password: new_password,
        password_confirmation: new_password
      },
      email: @user.email
    }
    # Assert password has changed.
    assert_not_equal false, @user.reload.authenticate(new_password)
    # Because on public computer someone could enter password change form one
    # more time:
    assert_nil @user.password_reset_token_digest
    assert_redirected_to root_path
    follow_redirect!
    assert_flash_notices success: { count: 1 }
  end

  test 'should NOT allow user change password after reset token expiration' do
    new_password = 'foobar'
    @user.send_password_reset_email

    # Lets simulate password reset request has been sent long time ago...
    @user.update_attribute(:sent_reset_at, 5.hours.ago)

    patch password_reset_path(@user.password_reset_token), params: {
      user: {
        password: new_password,
        password_confirmation: new_password
      },
      email: @user.email
    }

    assert_redirected_to root_path
    follow_redirect!
    assert_flash_notices danger: { count: 1 }
  end

  test 'should NOT allow user change password for invalid one' do
    # Incorrect new password.
    invalid_password_test('pass')
  end

  test 'should NOT allow user change password to empty one' do
    # Empty password.
    invalid_password_test('')
  end

  # Helper methods speciffied only to this file.

  def invalid_password_test(new_password)
    @user.send_password_reset_email
    patch password_reset_path(@user.password_reset_token), params: {
      user: {
        password: new_password,
        password_confirmation: new_password
      },
      email: @user.email
    }
    # Assert password has not changed
    assert_equal false, @user.reload.authenticate(new_password)
    assert_edit_form_layout
    assert_flash_notices danger: { count: 1 }
  end

  def assert_new_form_layout
    assert_select 'h3[class=?]', 'form-title', count: 1
    assert_select 'input[name=?][type=email]', 'password_reset[email]', count: 1
    assert_select 'input[type=submit]', count: 1
  end

  def assert_edit_form_layout
    assert_select 'h3[class=?]', 'form-title', count: 1
    assert_select 'input[name=?][type=password]', 'user[password]',
                  count: 1
    assert_select 'input[name=?][type=password]',
                  'user[password_confirmation]', count: 1
    assert_select 'input[name=email][type=hidden]', count: 1
    assert_select 'input[type=submit]', count: 1
  end
end
