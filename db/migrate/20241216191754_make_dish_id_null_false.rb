class MakeDishIdNullFalse < ActiveRecord::Migration[8.0]
  def change
    change_column :dish_entries, :dish_id, :integer, null: false
  end
end
