class DropAssetsDbFiles < ActiveRecord::Migration
  def up
    drop_table :assets
    drop_table :db_files
  end

  def down
  create_table "assets", :force => true do |t|
    t.string   "filename"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "db_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "home_id"
  end

  create_table "db_files", :force => true do |t|
    t.binary "data", :limit => 2147483647
  end

  end
end
