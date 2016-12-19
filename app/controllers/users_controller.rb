# :nodoc:
class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :friendly_forwarding, only: [:index, :show, :edit]
  before_action :redirect_if_not_logged_in, only: [:update, :destroy]
  before_action :redirect_if_not_an_admin, only: [:edit, :update, :destroy]
  before_action :redirect_if_insufficient_permissions, only: [:edit,
                                                              :update,
                                                              :destroy]

  def index
    # Index only activated users.
    @users = User.where(activated: true)
                 .paginate(page: params[:page],
                           per_page: KmForum::USERS_PER_PAGE)
  end

  def show
    # If given user isn't activated then only admin can see his profile.
    redirect_to(root_url) && return unless @user.activated? ||
                                           current_user.admin?
    if params[:activities] == 'topics'
      # Only last topics
      @activities = @user.recent_topics
      return
    elsif params[:activities] == 'posts'
      # Only last posts
      @activities = @user.recent_posts
      return
    else
      # All recent activities - posts and topics
      @activities = @user.recent_activities
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    # Newly created user can have only 'user' level permissions.
    @user.permissions = 'user'
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

  def edit; end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Account successfully updated.'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy
    flash[:success] = 'He deserved it. Bastard.'
    redirect_to users_path
  end

  private

  def user_params
    if logged_in? && current_user.admin?
      params.require(:user).permit(:name, :email, :avatar,
                                   :password, :password_confirmation,
                                   # Only admin can edit user permissions.
                                   :permissions)
    else
      params.require(:user).permit(:name, :email, :avatar,
                                   :password, :password_confirmation)
    end
  end

  def find_user
    @user = User.find(params[:id])
  end

  # Friendly forwarding works only for non logged in user and only for
  # HTTP GET requests.
  def friendly_forwarding
    return if logged_in?
    # Store for desired url for friendly forwarding.
    store_intended_url
    flash[:danger] = 'You must be logged in.'
    redirect_to login_path
  end

  # Should be used only for non-GET HTTP requests. Otherwise use
  # friendly_forwarding instead.
  def redirect_if_not_logged_in
    return if logged_in?
    flash[:danger] = 'Access denied.'
    redirect_to root_path
  end

  # Should be used when logged in user don't have rights to perform given action
  def redirect_if_insufficient_permissions
    return if current_user == @user ||
              current_user.admin? ||
              current_user.moderator?
    flash[:danger] = 'Access denied.'
    redirect_to root_path
  end

  # If someone is trying to access admin profile(@user.admin) and himself is
  # not an admin (!current_user.admin?), he should be redirected.
  def redirect_if_not_an_admin
    return unless @user.admin? && !current_user.admin?
    flash[:danger] = 'Access denied.'
    redirect_to root_path
  end
end
