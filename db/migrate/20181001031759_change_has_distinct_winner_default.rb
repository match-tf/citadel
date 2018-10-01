class ChangeHasDistinctWinnerDefault < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:league_matches, :has_winner, true)
  end
end
