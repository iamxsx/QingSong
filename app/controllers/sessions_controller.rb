class SessionsController < ApplicationController
  layout 'client/indexpages/register-layout'
  # get /login
  def login
    @page_tag = "login";
  end

  def create
    user = User.find_by_username(params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      store_in_session user
      redirect_to root_path
    else
      flash.now[:danger] = '无效的账号或密码'
      render 'sessions/login'
    end
  end


end
