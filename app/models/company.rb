class Company < ApplicationRecord
  mount_uploader :company_logo, FileUploader
end
