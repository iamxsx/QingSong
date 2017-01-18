class Admin::AdminApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_filter :logging?
  include Admin::SessionsHelper


  def logging?
    redirect_to '/admin/login' unless current_user
  end

end