class SessionsController < ApplicationController


  before_filter :is_login?

  layout 'client/indexpages/register-layout'
  # get /login
  def login
    @page_tag = "login";
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      store_in_session user
      redirect_to root_path
    else
      flash.now[:login_error] = '无效的账号或密码'
      render 'sessions/login'
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def session_params
    params.require(:session).permit(:email, :password)
  end


end
