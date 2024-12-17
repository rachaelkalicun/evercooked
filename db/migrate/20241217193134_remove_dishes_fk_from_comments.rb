class RemoveDishesFkFromComments < ActiveRecord::Migration[8.0]
  def change
    if foreign_key_exists?(:comments, :dishes)
      remove_foreign_key :comments, :dishes
    end
  end
end
