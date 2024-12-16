class CreateDishEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :dish_entries do |t|
      t.integer :dish_id
      t.datetime :date_cooked
      t.text :recipe_long_form
      t.text :backstory

      t.timestamps
    end
  end
end
