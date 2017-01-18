class InvitationCode < ApplicationRecord
  before_save :generate_invitation_code

  def generate_invitation_code
    self.code = SecureRandom.urlsafe_base64
  end
end
