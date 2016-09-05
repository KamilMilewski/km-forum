module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session.delete(:user_id)
    @current_user = nil
  end

  def find_current_user
    #Thanks to using ||= operator application is hitting database only first time
    @current_user ||= User.find_by(id: session[:user_id])
  end

  def logged_in?
    !find_current_user.nil?
  end
end
