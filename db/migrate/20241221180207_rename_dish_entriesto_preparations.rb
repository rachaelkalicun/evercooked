class RenameDishEntriestoPreparations < ActiveRecord::Migration[8.0]
  def change
    rename_table :dish_entries, :preparations
    drop_table :dish_entries_occasions
    create_join_table :occasions, :preparations, column_options: { null: true }
  end
end
