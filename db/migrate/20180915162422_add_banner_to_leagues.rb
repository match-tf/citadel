class AddBannerToLeagues < ActiveRecord::Migration[5.1]
  def change
    add_column :leagues, :banner, :string
  end
end
