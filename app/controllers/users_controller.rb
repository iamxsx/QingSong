class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :register_success]

  before_action :is_login?, only: [:user_center, :com_profile, :com_course, :com_employee, :emp_profile, :emp_course, :emp_exam]

  layout 'client/indexpages/register-layout', only: [:forget_password, :register_choose, :register_company, :register_employee, :register_success, :register_suspend]

  layout 'client/usercenter/usercenter', only: [:user_center, :com_course, :com_employee, :com_profile, :emp_course, :emp_exam, :emp_profile]


  # GET /register_choose
  def register_choose
  end

  # GET /register_employee
  def register_employee
    @user = User.new
  end

  # GET /register_company
  def register_company
    @user = User.new
    @company = Company.new
  end

  # 注册成功页面
  def register_success
  end

  #注册后待审核页面
  def register_suspend
  end

  # POST /register_employee
  def create_employee
    @user = User.new(user_params)
    # 查询邀请码
    invite_code = params[:user][:invite_code]
    # 邀请码存在且没有被使用
    if (invite_code && (code = InvitationCode.find_by_code(invite_code)) && !code.used?)
      @user.role_id = 1
      @user.company_id = code.company_id
      if @user.save
        flash.now[:success] = '注册成功'
        code.update_attribute(:used, true)
        code.update_attribute(:invited_at, Time.zone.now)
        render 'users/register_success'
        # redirect_to action: register_success, id: @user.id
      else
        flash.now[:error] = '注册失败'
        render :register_employee
      end
    else
      flash.now[:invite_code_error] = '查无此邀请码'
      render :register_employee
    end
  end


  # 忘记密码页面
  def forget_password
  end

  # 生成邮箱验证码
  def generate_email_verify_code
    email = params[:email]
    verify_code = User.generate_verify_code
    UserMailer.reset_password(email, verify_code).deliver_now
    session[:reset_password_verify_code] = verify_code
    render :json => {status: '200'}
  end

  def reset_password
    email, verify_code, password, password_confirmation = params[:email], params[:verifycode], params[:password], params[:password_confirmation]
    puts session[:reset_password_verify_code] == verify_code
    if session[:reset_password_verify_code] == verify_code
      user = User.find_by_email(email)
      if user.update({
                         :password => password,
                         :password_confirmation => password_confirmation
                     })
        redirect_to '/login'
      else
        flash.now[:reset_password_error] = '修改密码失败'
        render :forget_password
      end
    else
      flash.now[:reset_password_error] = '验证码错误'
      render :forget_password
    end

  end

  ####################################################
  ####################################################
  ####################################################
  ####################################################
  ####################################################
  # 后台页面

  # 用户个人中心
  def user_center
    @page_tag = "user_center"
  end

  # 公司-管理页面
  def com_profile
    @page_tag = "com_profile"
  end

  # 公司-员工管理页面
  def com_employee
    @page_tag = "com_employee"

    user = current_user
    company = user.company

    # 员工部分
    @employees_count = company.users.count
    @com_count= company.users.where(role_id: 2).count
    @employees = company.users

    # 邀请码部分
    @invite_codes = company.invitation_codes.where(used: false)

  end

  # 公司-课程管理页面
  def com_course
    @page_tag = "com_course"
  end

  # 用户-个人资料页面
  def emp_profile
    @page_tag = "emp_profile"
  end

  # 用户-我的课程页面
  def emp_course
    @page_tag = "emp_course"
  end

  # 用户-我的考核页面
  def emp_exam
    @page_tag = "emp_exam"
  end


  def manage_emp
    action_name = params[:do]
    emp_id = params[:emp_id]

    user = User.find(emp_id)

    case action_name
      when 'dismiss'
        user.update_attribute(:company_id, nil)
      when 'upgrade'
        user.update_attribute(:role_id, 2)
      when 'downgrade'
        user.update_attribute(:role_id, 1)
    end
    render :json => {
        :status => 'success',
        :err => nil
    }
  end

  def update_attr
    user = current_user
    user.update_attribute(:username, params[:user][:username])
    user.update_attribute(:email, params[:user][:email])
    user.update_attribute(:phone, params[:user][:phone])
    redirect_to '/users/emp-profile'
  end


  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    # 根据页面决定是哪种身注册方式
    @user.role_id = 1
    respond_to do |format|
      if @user.save
        # 发送邮件，等待激活
        UserMailer.account_activation(@user).deliver_now
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to emp_profile, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render emp_profile }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :invite_code, :phone)
    # params.permit(:emp_id, :do)
  end

end
