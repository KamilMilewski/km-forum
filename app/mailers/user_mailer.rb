# :nodoc:
class UserMailer < ApplicationMailer
  def account_activation(user, activation_token)
    @user = user
    @activation_token = activation_token
    @greeting = "Hi #{@user.name}"

    mail to: @user.email, subject: 'KMForum account activation'
  end

  def password_reset(user)
    @user = user
    @greeting = "Hi #{@user.name}"

    mail to: @user.email, subject: 'KMForum password reset'
  end
end
