class CreateTopicTable < ActiveRecord::Migration
  def change
    create_table "topics", force: true do |t|
      t.string "topic"
      t.timestamps null: false
    end
  end
end
