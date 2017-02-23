class AlterPartsToLesson < ActiveRecord::Migration[5.0]
  def change
    change_table :lessons do |t|
      t.remove :lesson_html_url, :lesson_js_url, :lesson_css_url, :lesson_json_url
      t.string :lesson_file_url
    end
  end
end
