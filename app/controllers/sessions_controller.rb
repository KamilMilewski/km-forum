class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      login(user)
      flash[:success] = 'You have been logged in successfully'
      redirect_to root_path
    else
      flash.now[:danger] = 'Invalid login/password combination.'
      render 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path
    flash[:success] = 'You have been logged out successfully.'
  end
end
