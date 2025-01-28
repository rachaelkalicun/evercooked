class FixOccasionHolidayRelationship < ActiveRecord::Migration[8.0]
  def change
    add_foreign_key :occasions, :holidays
    add_index :occasions, :holiday_id, unique: true
  end
end
