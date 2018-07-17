class AddRulesToLeagues < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :rules, :string, null: false, default: '### Welcome to match.tf tournament! Please follow the rules below:'
  end
end
