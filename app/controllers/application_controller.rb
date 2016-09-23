class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def check_login
    unless session[:user_id]
      flash[:notice] ="Please login to get access"
      redirect_to root_url
    end
  end

  def admin_login
    unless session[:role] == "Admin"
      flash[:notice] = "you dont have permission"
      redirect_to root_url
    end
  end
end
