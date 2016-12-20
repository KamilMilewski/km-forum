# :nodoc:
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

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
  # friendly_forwarding should be used.
  def redirect_if_not_logged_in
    return if logged_in?
    flash[:danger] = 'Access denied.'
    redirect_to root_path
  end
end
