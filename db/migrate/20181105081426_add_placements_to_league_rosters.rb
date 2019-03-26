class AddPlacementsToLeagueRosters < ActiveRecord::Migration[5.2]
  def change
    add_column :league_rosters, :placement, :integer
  end
end