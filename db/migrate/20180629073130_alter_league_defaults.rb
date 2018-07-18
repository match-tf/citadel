class AlterLeagueDefaults < ActiveRecord::Migration[5.0]
  def change
    change_column_default(:leagues, :transfers_require_approval, false)
    change_column_default(:leagues, :points_per_match_win, 2)
    change_column_default(:leagues, :points_per_match_draw, 1)
    change_column_default(:leagues, :points_per_forfeit_win, 1)
    change_column_default(:leagues, :points_per_round_win, 0)
    change_column_default(:leagues, :points_per_round_draw, 0)
    change_column_default(:leagues, :points_per_forfeit_draw, 0)
  end
end
