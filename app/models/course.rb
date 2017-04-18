class Course < ApplicationRecord

  belongs_to :lesson
  has_many :user_courses

  attr_accessor :distribute

  def attributes
   {
       'course_file_id': nil,
       'course_name': nil,
       'distribute': nil
   }
  end

end
