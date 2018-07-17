class AddHeroimageToLeagues < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :heroimage, :string, null: false, default: '/assets/images/fallback/heroimage_default.png'
    add_column :leagues, :heroimage_display, :boolean, null: false, default: false
  end
end
