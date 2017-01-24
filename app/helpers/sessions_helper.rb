module SessionsHelper

  # 是否已登录
  def is_login?
      # redirect_to root_path if current_user
  end

  # 获得当前用户
  def current_user
    User.find(session[:user_id])
  end

  # 将已登录的用户存储在session中
  def store_in_session(user)
    session[:user_id] = user.id
  end
end
