class Lesson < ApplicationRecord

  belongs_to :company
  has_many :courses
  mount_uploader :lesson_cover, FileUploader
  mount_uploader :lesson_file_url, LessonCompressFileUploader

end
