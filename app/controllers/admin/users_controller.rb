class Admin::UsersController < Admin::AdminApplicationController

  layout 'admin'

  before_action :set_score, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_users_path, notice: 'User was successfully created.'
    else
      render :new
    end
  end

  def new
    @user = User.new
  end

  def show
  end

  def edit
  end

  def update
    if @user.update_columns(
             {
                 :username => params[:user][:username],
                 :phone => params[:user][:phone],
                 :email => params[:user][:email],
                 :role_id => params[:user][:role_id],
                 :company_id => params[:user][:company_id],
             }
    )
      redirect_to admin_users_path, notice: 'User was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to admin_users_path, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_score
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation, :role_id, :company_id, :phone)
    end
end
