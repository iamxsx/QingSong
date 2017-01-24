class AddCompanyToInvitationCodes < ActiveRecord::Migration[5.0]
  def change
    add_reference :invitation_codes, :company, foreign_key: true
  end
end
