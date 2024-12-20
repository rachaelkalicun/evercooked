class JoinOccasionsToDishEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :dish_entries_occasions, id: false do |t|
      t.belongs_to :dish_entries
      t.belongs_to :occasions
    end
  end
end
