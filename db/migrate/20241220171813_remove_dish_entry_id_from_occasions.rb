class RemoveDishEntryIdFromOccasions < ActiveRecord::Migration[8.0]
  def change
    remove_column :occasions, :dish_entry_id, :integer
  end
end
