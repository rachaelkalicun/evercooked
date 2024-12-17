class ChangeDishBodyToDescription < ActiveRecord::Migration[8.0]
  def change
    rename_column :dishes, :body, :description
  end
end
