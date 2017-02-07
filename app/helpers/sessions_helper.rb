module SessionsHelper

  # 是否已登录
  def is_login?
      redirect_to root_path unless current_user
  end

  # 获得当前用户
  def current_user
    if (user_id = session[:user_id])
      User.find(user_id)
    end
  end

  # 将已登录的用户存储在session中
  def store_in_session(user)
    session[:user_id] = user.id
  end

  def logout
    session.delete(:user_id)
  end


end
