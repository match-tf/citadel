class RenameDisplayHeroimageToDisplay < ActiveRecord::Migration[5.1]
  def change
    rename_column :leagues, :display_heroimage, :display
    change_column_default :leagues, :display, true
  end
end
