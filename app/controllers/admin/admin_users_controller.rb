class Admin::AdminUsersController < Admin::AdminApplicationController
  before_action :set_admin_admin_user, only: [:show, :edit, :update, :destroy]

  layout 'admin'
  # GET /admin/admin_users
  # GET /admin/admin_users.json
  def index
    @admin_admin_users = Admin::AdminUser.all
  end

  # GET /admin/admin_users/1
  # GET /admin/admin_users/1.json
  def show
  end

  # GET /admin/admin_users/new
  def new
    @admin_admin_user = Admin::AdminUser.new
  end

  # GET /admin/admin_users/1/edit
  def edit
  end

  # POST /admin/admin_users
  # POST /admin/admin_users.json
  def create
    @admin_admin_user = Admin::AdminUser.new(admin_admin_user_params)

    respond_to do |format|
      if @admin_admin_user.save
        format.html { redirect_to @admin_admin_user, notice: 'Admin user was successfully created.' }
        format.json { render :show, status: :created, location: @admin_admin_user }
      else
        format.html { render :new }
        format.json { render json: @admin_admin_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/admin_users/1
  # PATCH/PUT /admin/admin_users/1.json
  def update
    respond_to do |format|
      if @admin_admin_user.update(admin_admin_user_params)
        format.html { redirect_to @admin_admin_user, notice: 'Admin user was successfully updated.' }
        format.json { render :show, status: :ok, location: @admin_admin_user }
      else
        format.html { render :edit }
        format.json { render json: @admin_admin_user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/admin_users/1
  # DELETE /admin/admin_users/1.json
  def destroy
    @admin_admin_user.destroy
    respond_to do |format|
      format.html { redirect_to admin_admin_users_url, notice: 'Admin user was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_admin_admin_user
    @admin_admin_user = Admin::AdminUser.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def admin_admin_user_params
    params.require(:admin_admin_user).permit(:email, :password, :password_confirmation)
  end
end
