json.extract! invitation_code, :id, :code, :used, :invited_at, :created_at, :updated_at
json.url invitation_code_url(invitation_code, format: :json)