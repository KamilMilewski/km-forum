class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]
  before_action :redirect_if_not_logged_in, only: [:edit, :update]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show

  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.permissions = 'admin'
    if @user.save
      login @user
      redirect_to @user
      flash[:success] = 'Account successfuly created. Welcome aboard!'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = 'Account successfuly updated.'
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
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
      unless logged_in?
        flash[:danger] = 'You must be logged in.'
        redirect_to login_path
      end
    end
end
