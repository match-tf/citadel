class AddRulesRenderCacheToLeagues < ActiveRecord::Migration[5.0]
  def change
    add_column :leagues, :rules_render_cache, :text, null: false, default: ''
  end
end
