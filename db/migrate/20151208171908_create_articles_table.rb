class CreateArticlesTable < ActiveRecord::Migration
  def change
    create_table "articles", force: true do |t|
      t.integer "topic_id"
      t.string "title"
      t.text "url"
      t.string "source"
      t.text "content"
      t.integer "score"
      t.text "type"
      t.timestamps null: false
    end
  end
end
