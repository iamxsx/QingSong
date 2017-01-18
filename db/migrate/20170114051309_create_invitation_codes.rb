class CreateInvitationCodes < ActiveRecord::Migration[5.0]
  def change
    create_table :invitation_codes do |t|
      t.string :code
      t.boolean :used, default: false
      t.datetime :invited_at

      t.timestamps
    end
  end
end
