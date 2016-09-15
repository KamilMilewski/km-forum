class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      login @user
      params[:session][:remember_me_checkbox] == '1' ? remember(@user) : forget(@user)
      flash[:success] = 'You have been logged in successfully'
      redirect_to root_path
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
