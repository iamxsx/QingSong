class AddDefaultValueToUserCourse < ActiveRecord::Migration[5.0]
  def change
    change_column_default :user_courses, :progress, 0
    change_column_default :user_courses, :score, 0
    change_column_default :user_courses, :is_finished, false
  end
end
