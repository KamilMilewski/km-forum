# :nodoc:
class PasswordResetsController < ApplicationController
  before_action :find_user, only: [:edit, :update]
  before_action :redirect_if_invalid_token, only: [:edit, :update]
  before_action :redirect_if_token_expired, only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    # Password reset email should be sent only to existing, activated user.
    if @user && @user.activated?
      @user.send_password_reset_email
      flash[:info] = 'Password reset email has been sent. Please check your' \
                     ' mailbox.'
      flash[:info] += " Since this is only a demo page, here is your activation
                     link:   "
      flash[:info] += edit_password_reset_url(@user.password_reset_token,
                                              email: @user.email)
      redirect_to root_url
    elsif @user && !@user.activated?
      flash[:danger] = 'Can\'t reset password for not activated user.'
      redirect_to root_url
    else
      flash.now[:danger] = 'There is no user with such an email in database.'
      render 'new'
    end
  end

  def edit
    # edit action is invoken by user clicking on the link he receives in
    # password reset email.
    # It has construction as follows:
    # https://site_address/password_resets/
    # password_reset_token/edit?email=user%40email.com
    # Example:
    # https://localhost:3000/password_resets/NE3jTHpPJ8aFEuOJSIACuQ/edit?email=user%40user.com
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, 'can\'t be blank.')
      render 'edit'
    elsif @user.update_attributes(user_params)
      # password_reset_token_digest has to be set to nil for security reasons.
      # Otherwise, after password change, some villain could click browser back
      # button and get to change password form. Then he could change password
      # once again.
      @user.update_attribute(:password_reset_token_digest, nil)
      flash[:success] = 'Successfully changed password.'
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def find_user
    @user = User.find_by(email: params[:email])
  end

  # Redirects if received password reset token dosent corresponds to the one
  # stored in db.
  def redirect_if_invalid_token
    return if @user.authenticated?(:password_reset, params[:id])
    flash[:danger] = 'Password reset token invalid.'
    redirect_to root_path
  end

  def redirect_if_token_expired
    return unless @user.password_reset_token_expired?
    flash[:danger] = 'Password reset request expired.'
    redirect_to root_path
  end
end
