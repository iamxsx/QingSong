class AddLessonIdToCourse < ActiveRecord::Migration[5.0]
  def change
    add_reference :courses, :lesson, foreign_key: true
  end
end
