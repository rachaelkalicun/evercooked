class CreateComments < ActiveRecord::Migration[8.0]
  def change
    create_table :comments do |t|
      t.references :dish, null: false, foreign_key: true
      t.text :context

      t.timestamps
    end
  end
end
