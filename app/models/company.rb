class Company < ApplicationRecord

  mount_uploader :company_logo, FileUploader

  has_many :users

  has_many :invitation_codes

end
