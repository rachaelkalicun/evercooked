class ChangeTitleTypeInDishes < ActiveRecord::Migration[8.0]
  def change
    change_column :dishes, :title, :text
  end
end
