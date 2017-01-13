module SessionsHelper

  # 是否已登录
  def is_logging

  end

  # 获得当前用户
  def get_current_user

  end

  # 将已登录的用户存储在session中
  def store_in_session(user)
    session[:user_id] = user.id
  end
end
