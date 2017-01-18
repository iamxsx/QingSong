json.extract! company, :id, :company_name, :company_desc, :company_logo, :activated, :activated_at, :created_at, :updated_at
json.url company_url(company, format: :json)