class AddUserToDishes < ActiveRecord::Migration[8.0]
  def change
    add_reference :dishes, :user, null: true, foreign_key: true

    Dish.update_all(user_id: User.first.id)

    change_column_null :dishes, :user_id, false
  end
end
