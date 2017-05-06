# 操作管理员session的辅助类
module Admin::SessionsHelper

  # 管理员是否已登录
  def is_admin_and_login
    redirect_to '/admin/login' unless current_admin
  end

  # 将登录的管理员存在session中
  def store_in_session (user)
    session[:admin_user_id] = user.id
  end

  # 获得当前登录的管理员
  def current_admin
    if (admin_user_id = session[:admin_user_id])
      User.find(admin_user_id)
    end
  end

  # 管理员退出登录
  def logout
    session.delete(:admin_user_id)
  end
end
