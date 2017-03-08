class CreateUserLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :user_lessons do |t|

      t.belongs_to :user, index: true
      t.belongs_to :lesson, index: true
      t.integer :status
      t.integer :score
      t.timestamps
    end
  end
end
