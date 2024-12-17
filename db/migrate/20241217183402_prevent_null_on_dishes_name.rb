class PreventNullOnDishesName < ActiveRecord::Migration[8.0]
  def change
    change_column :dishes, :name, :text, null: false
  end
end
