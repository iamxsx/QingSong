class Admin::LoginAndRegisterController < Admin::AdminApplicationController
  layout 'admin-login'
  before_action :is_admin_and_login, :except => %w(login register)

  def login
  end

  def register
  end

end
