class RenameHeroimageToHeroimageUrl < ActiveRecord::Migration[5.0]
  def change
    rename_column :leagues, :heroimage, :heroimage_url
    rename_column :leagues, :heroimage_display, :display_heroimage
  end
end
