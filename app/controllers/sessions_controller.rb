# :nodoc:
class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      if @user.activated?
        login @user
        if params[:session][:remember_me_checkbox] == '1'
          remember(@user)
        else
          forget(@user)
        end
        flash[:success] = 'You have been logged in successfully'
        redirect_back_or root_url
      else
        message = 'Account not activated. '
        message += 'Check your email for the activation link.'
        flash[:warning] = message
        redirect_to root_url
      end
    else
      flash.now[:danger] = 'Invalid login/password combination.'
      render 'new'
    end
  end

  def destroy
    logout if logged_in?
    redirect_to root_path
    flash[:success] = 'You have been logged out successfully.'
  end
end
