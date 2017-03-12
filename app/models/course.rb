class Course < ApplicationRecord

  belongs_to :lesson

  has_many :user_courses

end
