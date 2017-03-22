class RemoveLessonIdToUserCourse < ActiveRecord::Migration[5.0]
  def change
    change_table :user_courses do |t|
      t.remove :lesson_id
    end
  end
end
