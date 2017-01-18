class Admin::SessionsController < Admin::AdminApplicationController

  before_filter :logging?, :except => :create

  def destroy
    logout
  end

  def create
    user = Admin::AdminUser.find_by_email(params['email'])
    if user && user.authenticate(password = params['password'])
      store_in_session user
      redirect_to '/admin/'
    else
      redirect_to '/admin/login'
    end
  end
end
