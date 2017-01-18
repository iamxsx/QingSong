class Lesson < ApplicationRecord
  belongs_to :company
  mount_uploader :lesson_cover, FileUploader
  mount_uploader :lesson_json_url, JsonUploader
  mount_uploader :lesson_html_url, HtmlUploader
  mount_uploader :lesson_js_url, JsUploader
  mount_uploader :lesson_css_url, CssUploader
end
