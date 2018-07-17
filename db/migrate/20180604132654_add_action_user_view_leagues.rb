class AddActionUserViewLeagues < ActiveRecord::Migration[5.0]
  def change
    create_table(:action_user_view_leagues) do |t|
      t.column :user_id, :integer
      t.index :user_id, unique: true  
    end	  
  end
end
