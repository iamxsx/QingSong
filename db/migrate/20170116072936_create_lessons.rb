class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.string :lesson_name
      t.string :lesson_desc
      t.string :lesson_cover
      t.string :lesson_json_url
      t.string :lesson_html_url
      t.string :lesson_js_url
      t.string :lesson_css_url
      t.references :company, foreign_key: true

      t.timestamps
    end
  end
end
