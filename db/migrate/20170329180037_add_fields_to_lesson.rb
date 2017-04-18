class AddFieldsToLesson < ActiveRecord::Migration[5.0]

  def change
    add_column :lessons, :state, :string
    add_column :lessons, :version, :string
    add_column :lessons, :preview, :boolean
    add_column :lessons, :preview_url, :string
  end

end
