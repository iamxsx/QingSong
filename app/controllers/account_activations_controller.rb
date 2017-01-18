# 账号激活控制器
class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      #修改激活状态
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      store_in_session user
      flash[:success] = '激活成功'
    else
      flash[:danger] = '激活失败'
    end
    redirect_to root_path
  end

end
