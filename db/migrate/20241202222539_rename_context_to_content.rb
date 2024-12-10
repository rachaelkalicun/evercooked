class RenameContextToContent < ActiveRecord::Migration[8.0]
  def change
    rename_column :comments, :context, :content
  end
end
