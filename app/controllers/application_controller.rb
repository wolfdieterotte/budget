class ApplicationController < ActionController::Base
  
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_filter :user_time_zone, :if => :current_user

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = "Please log into your account to access this section."
    redirect_to root_url
  end
  
  private

    def current_user
      @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
    end
    helper_method :current_user

    def user_time_zone(&block)
      Time.use_zone(current_user.time_zone, &block)
    end

end
