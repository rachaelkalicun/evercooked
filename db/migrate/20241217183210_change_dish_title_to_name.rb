class ChangeDishTitleToName < ActiveRecord::Migration[8.0]
  def change
    rename_column :dishes, :title, :name
  end
end
