class CompaniesController < ApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]

  # GET /company/send-verify-code
  def send_verify_code
    email = params[:email]
    random_token = User.generate_random_token[0, 4].downcase
    UserMailer.account_activation(email, random_token).deliver_now
    session[:company_verify_code] = random_token
  end

  # POST /register-company
  def create_company
    verify_code = session[:company_verify_code]
    if (verify_code && verify_code == params[:verifycode])
      @company = Company.new(:company_name => params[:company_name],
                             :company_address => params[:company_address],
                             :company_tel => params[:company_tel]
      )
      if @company.save
        @user = User.new(:username => params[:username],
                         :password => params[:password],
                         :password_confirmation => params[:password_confirmation],
                         :email => params[:email]
        )
        @user.company_id = @company.id
        @user.role_id = 2
        if @user.save
          render 'users/register_suspend'
          return
        else
          flash.now[:error] = '高级管理员注册失败'
        end
      else
        flash.now[:error] = '公司入驻失败'
      end
    else
      flash.now[:verify_code_error] = '邮箱验证码错误'
    end
    render 'users/register_company'
  end

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
    # @companies = Company.all.map { |company|
    #   [company.id, company.company_name]
    # }
  end

  # GET /companies/1
  # GET /companies/1.json
  def show
  end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit
  end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = Company.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def company_params
    params.require(:company).permit(:company_name, :company_desc, :company_logo)
    params.permit(:company_name, :company_address, :company_tel, :email, :verifycode, :username, :password, :password_confirmation)
  end
end