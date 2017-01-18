class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  include InvitationCodesHelper

  def set_admin_locale
    I18n.locale = :"zh-CN"
  end

end
