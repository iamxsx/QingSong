class Admin::LoginAndRegisterController < Admin::AdminApplicationController
  layout 'admin-login'
  before_filter :logging?, :except => %w(login register)

  def login
  end

  def register
  end

end
