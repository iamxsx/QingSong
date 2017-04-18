class CreateApplyLessons < ActiveRecord::Migration[5.0]

  def change
    create_table :apply_lessons do |t|
      t.string :course_sys_name_cn
      t.string :course_sys_desc
      t.string :course_sys_cover
      t.timestamps
    end
  end

end
