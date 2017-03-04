class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  include InvitationCodesHelper
  include TimeHelper
  include SysHelper


end
