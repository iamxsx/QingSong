class Admin::CompaniesController < Admin::AdminApplicationController
  before_action :set_company, only: [:show, :edit, :update, :destroy]
  layout 'admin'

  def index
    @companies = Company.all
  end

  def show
  end

  def new
    @company = Company.new
  end

  def edit
  end

  def active
    company_id = params[:company_id]
    company = Company.find(company_id)
    company.update_columns({
                               :activated => 1,
                               :activated_at => Time.now
                           })
    redirect_to '/admin/notices'
  end

  def create
    @company = Company.new(company_params)
    respond_to do |format|
      if @company.save
        format.html { redirect_to admin_companies_path, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to admin_companies_path, notice: 'Company was successfully updated.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to admin_companies_path, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  def set_company
    @company = Company.find(params[:id])
  end

  def company_params
    params.require(:company).permit(:company_name, :company_desc, :company_logo, :activated, :activated_at)
  end


end
