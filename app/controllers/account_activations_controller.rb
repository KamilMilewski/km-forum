# :nodoc:
class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(email: params[:email])
    # User will be activated only when:
    # 1. User with given email exist at all (first condition)
    # 2. User hasn't been activated already. Otherwise attacker that obtained
    # activation_token could send account activation link and then log in right
    # away.
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.activate
      login user
      flash[:success] = 'Account activated!'
      redirect_to user
    else
      flash[:danger] = 'Invalid activation link.'
      redirect_to root_url
    end
  end
end
