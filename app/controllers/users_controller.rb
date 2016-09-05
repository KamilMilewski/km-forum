class UsersController < ApplicationController
  before_action :find_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
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
      login(@user)
      redirect_to @user
      flash[:success] = 'Account successfully created. Welcome aboard!'
    else
      render 'new'
    end
  end

  def edit
  end

  def update
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
end
