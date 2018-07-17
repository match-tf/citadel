class RenameHeroimageDefaultUrl < ActiveRecord::Migration[5.0]
  def change
    change_column_default :leagues, :heroimage_url, '/images/heroimage_default.png'
  end
end
