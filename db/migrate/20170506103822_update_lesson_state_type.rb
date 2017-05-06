class UpdateLessonStateType < ActiveRecord::Migration[5.0]
  def change
    change_column :lessons, :state, :integer
  end
end
