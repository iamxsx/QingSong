class InvitationCode < ApplicationRecord

  before_create :generate_random_code

  belongs_to :company

  def generate_random_code
    self.code = (0...6).map {
      ('A'..'Z').to_a[rand(26)]
    }.join
  end
end
