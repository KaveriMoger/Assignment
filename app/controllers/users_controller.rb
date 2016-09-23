class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    user = User.new(user_params)
    render 'new' unless user.save
    user.role == "Admin" ? redirect_to(users_path) : users_path(user)
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    render 'edit' unless user.upadate_attributes(user_params)
    user.role == "Admin" ? redirect_to(users_path) : users_path(user)
  end

  def show
    @user = User.find(params[:id])
  end

  def make_admin
    user = User.find(params[:id])
    render :json =>{:status => false, :message => "You do not have sufficient permission"} and return unless session[:role] == "Admin"
    user.update_attributes(:role => "admin")
    render :json => {:status => true, :message => "User upgraded to admin"}
  end

  def downgrade_admin
    user = User.find(params[:id])
    render :json => {:status => false,:message => "You dont have sufficient permission"} and return unless session[:role] == "Admin"
    render :json => {:status => false, :message => "You are thelast admen"} and return if  (User.where(:role =>"Admin").count == 1)
    user.update_attributes(:role => "user")
    render :json => {:status => true, :message => "Admin Downgraded to User"}
  end

  def change_password
    @user = User.find(params[:id])
  end

  def submit_change_password
    user = User.find(params[:id])
    if user.password != paramas[:old_password]
      flash[:notice] = "old password doesnot match"
      redirect_to change_password_path
    elsif params[:password] != params[:confirmation_password]
      flash[:notice] = "confirmation password doesnot match"
      redirect_to change_password_path
      user.update_attributes(password:params[:password])
      redirect_to(user)
    end
  end

  private
  def user_params
    if user[:role] == "Admin"
      params.require(:user).permit(:email, :password, :first_name, :last_name, :role)
    else
      params.require(:user).permit(:email,:first_name, :last_name)
    end
  end


end
