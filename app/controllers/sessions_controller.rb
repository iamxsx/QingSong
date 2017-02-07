class SessionsController < ApplicationController


  # before_action :is_login?

  layout 'client/indexpages/register-layout'
  # GET /login
  def login
    @page_tag = "login";
  end

  # 登陆
  # POST /login
  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      store_in_session user
      $last_login_time = cookies[:last_login_time] ? cookies[:last_login_time] : '首次登陆'
      cookies[:last_login_time] = current_time
      redirect_to '/users/user-center'
    else
      flash.now[:login_error] = '无效的账号或密码'
      render 'sessions/login'
    end
  end

  # 注销
  # get /logout
  def destroy
    logout
    render nothing: true
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def session_params
    params.require(:session).permit(:email, :password)
  end


end
