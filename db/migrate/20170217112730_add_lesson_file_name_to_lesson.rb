class AddLessonFileNameToLesson < ActiveRecord::Migration[5.0]
  def change
    add_column :lessons, :lesson_file_name, :string
  end
end
