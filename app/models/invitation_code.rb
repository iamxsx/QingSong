class InvitationCode < ApplicationRecord
  before_save :generate_random_code

  def generate_random_code
    self.code = (0...6).map {
      ('A'..'Z').to_a[rand(26)]
    }.join
  end
end
