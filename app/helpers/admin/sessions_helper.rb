module Admin::SessionsHelper

  def store_in_session (user)
    session[:admin_user_id] = user.id
  end

  def current_user
    if (admin_user_id = session[:admin_user_id])
      Admin::AdminUser.find(admin_user_id)
    end
  end



end
