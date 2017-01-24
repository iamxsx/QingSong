class Company < ApplicationRecord
  mount_uploader :company_logo, FileUploader
  has_many :user
end
