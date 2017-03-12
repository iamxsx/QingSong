class CreateUserCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :user_courses do |t|

      t.belongs_to :user, index: true
      t.belongs_to :course, index:true
      t.integer :lesson_id, index:true

      t.text :html_file
      t.integer :step
      t.integer :action
      t.integer :progress
      t.boolean :is_finished
      t.integer :score

      t.timestamps
    end
  end
end
