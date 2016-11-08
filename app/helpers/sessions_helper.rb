module SessionsHelper
  def login(user)
    session[:user_id] = user.id
  end

  def logout
    session.delete(:user_id)
    forget(@current_user) if logged_in?
    @current_user = nil
  end

  # Sets two cookies related to remembering user.
  # First cookie: user_id is an encrypted and signed user id.
  # Second cookie: remember_token is an random string. Its digested version is
  # stored in db.
  def remember(user)
    # In this method virutal user attr 'remember_token' is set.
    # After that, based on 'remember_token', 'remember_token_digest' attr. is set.
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  # Assigns nil to user remember_token and remember_token_digest attributes.
  # Deletes all cookies related to remembering user.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Returns current logged in user if any exist.
  def find_current_user
    if(user_id = session[:user_id])
      # Thanks to using ||= operator application is hitting database only first time.
      @current_user ||= User.find_by(id: user_id)
    elsif(user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        login user
        @current_user = user
      end
    end
  end

  # Checks if given user is a current logged in user.
  def current_user?(user)
    find_current_user == user
  end

  def logged_in?
    !find_current_user.nil?
  end

  # Friendly forwarding: if non logged in user tries to access page that require
  # to be logged in - he should be redirected first to logging page and then,
  # after logging in - to the page he was trying to access from the beginning.

  # Friendly forwarding helper. Stores desired url in session cookie - but only
  # if it was a GET request.
  def store_intended_url
    session[:forwarding_url] = request.original_url if request.get?
  end

  # Friendly forwarding helper. Redirects to forwarding_url if exist - otherwise
  # forwards to default_url.
  def redirect_back_or(default_url)
    redirect_to(session[:forwarding_url] || default_url)
    session.delete(:forwarding_url)
  end
end
