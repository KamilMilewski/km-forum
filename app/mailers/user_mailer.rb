# :nodoc:
class UserMailer < ApplicationMailer
  def account_activation(user)
    @user = user
    @greeting = "Hi #{@user.name}"

    mail to: @user.email, subject: 'KM-Forum account activation'
  end

  def password_reset(user)
    @user = user
    @greeting = "Hi #{@user.name}"

    mail to: @user.email, subject: 'KM-Forum password reset'
  end
end
