class CreateOccasions < ActiveRecord::Migration[8.0]
  def change
    create_table :occasions do |t|
      t.integer :holiday_id
      t.integer :preparation_id

      t.timestamps
    end
  end
end
