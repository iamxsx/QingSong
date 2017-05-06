class Admin::SessionsController < Admin::AdminApplicationController

  before_filter :is_admin_and_login, :except => :create

  def destroy
    logout
  end

  def create
    user = User.find_by_email(params['email'])
    if user && user.authenticate(password = params['password']) && user.role.id == 3
      store_in_session user
      redirect_to '/admin/'
    else
      redirect_to '/admin/login'
    end
  end
end
