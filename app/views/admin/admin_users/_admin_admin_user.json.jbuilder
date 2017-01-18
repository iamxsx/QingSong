json.extract! admin_admin_user, :id, :email, :password_digest, :created_at, :updated_at
json.url admin_admin_user_url(admin_admin_user, format: :json)