class RemoveDuplicatesAndAddIndexToDishesName < ActiveRecord::Migration[8.0]
  def up
    # Remove duplicate rows
    execute <<-SQL
      DELETE FROM dishes
      WHERE id NOT IN (
        SELECT MIN(id)
        FROM dishes
        GROUP BY name
      )
    SQL

    # Add unique index
    add_index :dishes, :name, unique: true
  end

  def down
    remove_index :dishes, :name
  end
end
