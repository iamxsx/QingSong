class Admin::UsersController < Admin::AdminApplicationController

  layout 'admin'
  # GET /admin/users
  # GET /admin/users.json
  def index
    @users = User.all
  end

end
