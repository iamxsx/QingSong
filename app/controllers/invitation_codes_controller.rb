class InvitationCodesController < ApplicationController
  before_action :set_invitation_code, only: [:show, :edit, :update, :destroy]

  # 生成邀请码
  # 验证邀请码

  # GET /invitation_codes
  # GET /invitation_codes.json
  def index
    @invitation_codes = InvitationCode.all
    @invitation_code = InvitationCode.new
  end

  # GET /invitation_codes/1
  # GET /invitation_codes/1.json
  def show
  end


  # GET /invitation_codes/1/edit
  def edit
    invitation_code = InvitationCode.find(params[:id])
    if invitation_code && !invitation_code.used?
      invitation_code.update_attribute(:used, true)
      invitation_code.update_attribute(:invited_at, Time.zone.now)
      render json: {
          msg: 'success'
      }
    else
      render json: {
          msg: 'failed'
      }
    end

  end

  # POST /invitation_codes
  # POST /invitation_codes.json
  def create
    @invitation_code = InvitationCode.new()
    if @invitation_code.save
      render json: {
          invitation_code: @invitation_code.code
      }
    end

    # respond_to do |format|
    #   if @invitation_code.save
    #     format.html { redirect_to @invitation_code, notice: 'Invitation code was successfully created.' }
    #     format.js {}
    #     format.json { render :show, status: :created, location: @invitation_code }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @invitation_code.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /invitation_codes/1
  # PATCH/PUT /invitation_codes/1.json
  def update
    respond_to do |format|
      if @invitation_code.update(invitation_code_params)
        format.html { redirect_to @invitation_code, notice: 'Invitation code was successfully updated.' }
        format.json { render :show, status: :ok, location: @invitation_code }
      else
        format.html { render :edit }
        format.json { render json: @invitation_code.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /invitation_codes/1
  # DELETE /invitation_codes/1.json
  def destroy
    @invitation_code.destroy
    respond_to do |format|
      format.html { redirect_to invitation_codes_url, notice: 'Invitation code was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_invitation_code
    @invitation_code = InvitationCode.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def invitation_code_params
    params.require(:invitation_code).permit(:code, :used, :invited_at)
  end
end
