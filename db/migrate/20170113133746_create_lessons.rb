class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.string :lesson_name
      t.string :image_url

      t.timestamps
    end
  end
end
