module InvitationCodesHelper

  def generate_invitation_code
    SecureRandom.urlsafe_base64
  end


end
