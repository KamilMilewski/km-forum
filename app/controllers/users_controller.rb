# :nodoc:
class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_not_logged_in, only: [:index,
                                                   :edit,
                                                   :update,
                                                   :delete]
  before_action :redirect_if_user_cant_access, only: [:edit, :update]

  def index
    # Index only activated users.
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    # If given user isn't activated then only admin can see his profile.
    redirect_to(root_url) && return unless @user.activated? ||
                                           current_user.admin?
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @user.send_activation_email
      flash[:info] = 'Please check your email for an activation link.'
      flash[:info] += " Since this is only a demo page, here is your activation
      link:   "
      flash[:info] += edit_account_activation_url(@user.activation_token,
                                                  email: @user.email)
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Account successfully updated.'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    if !current_user.nil? && current_user.admin?
      @user.destroy
      flash[:success] = 'He deserved it. Bastard.'
      redirect_to users_path
    else
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email,
                                 :password, :password_confirmation)
  end

  def find_user
    @user = User.find(params[:id])
  end

  def redirect_if_not_logged_in
    return if logged_in?
    # Store for desired url for friendly forwarding.
    store_intended_url
    flash[:danger] = 'You must be logged in.'
    redirect_to login_path
  end

  def redirect_if_user_cant_access
    # editing user is restricted to user who owns the profile or to an admin
    # who can edit every profile.
    redirect_to root_path unless current_user?(@user) || current_user.admin?
  end
end
