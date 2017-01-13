json.extract! lesson, :id, :lesson_name, :image_url, :created_at, :updated_at
json.url lesson_url(lesson, format: :json)