class SessionsController < ApplicationController
  layout "application", only: [:new]
  def new
  end
  def create 
    @user = User.find_by_email(params[:Email])
    if @user && @user.authenticate(params[:Password])
      session[:user_id] = @user.id
      redirect_to "/users/#{@user.id}"
    else 
      flash[:errors] = ["Invalid Combination"]
      redirect_to "/sessions/new"
    end
  end 
  def destroy 
    reset_session
    redirect_to "/sessions/new"
  end 
end
