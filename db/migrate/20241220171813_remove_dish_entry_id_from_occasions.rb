class RemovePreparationIdFromOccasions < ActiveRecord::Migration[8.0]
  def change
    remove_column :occasions, :preparation_id, :integer
  end
end
