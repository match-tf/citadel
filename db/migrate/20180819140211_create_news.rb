class CreateNews < ActiveRecord::Migration[5.1]
  def change
    create_table :news do |t|
      t.string :title, null: false
      t.string :content, null: false
      t.text :content_render_cache
      t.integer :author_id, null: false, index: true
      t.string :twitter_url
      t.string :shorttext, null: false
      t.string :image, null: false

      t.timestamps null: false
    end

    add_foreign_key :news, :users, column: :author_id
  end
end
