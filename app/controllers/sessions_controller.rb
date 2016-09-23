class SessionsController < ApplicationController
  def create
    user = user.where("emial = ? and password = ?",params[:email],params[:password]).first
    if user
      reset_session
      session[:user_id] = user.id
      session[:role] = user.role
      user.role == "Admin" ? (redirect_to users_path) : (redirect_to users_path(user))
    else
      flash[:notice] = "user does not exist"
      render 'new'
    end
  end

  def destroy
    reset_session
    flash[:notice] = "Thank You, visit again"
    redirect_to root_url
  end
end
