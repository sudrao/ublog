# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110705231052) do

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

  create_table "blogs", :force => true do |t|
    t.string   "content"
    t.integer  "home_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "to_id"
    t.integer  "is_private"
    t.string   "source"
    t.integer  "thread"
    t.integer  "prev_in_thread"
    t.string   "proxy"
    t.integer  "in_solr"
  end

  add_index "blogs", ["created_at"], :name => "created_index"
  add_index "blogs", ["home_id"], :name => "home_index"
  add_index "blogs", ["in_solr"], :name => "in_solr_index"
  add_index "blogs", ["to_id"], :name => "to_index"

  create_table "cross_posts", :force => true do |t|
    t.integer  "yammer_last_id", :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "db_files", :force => true do |t|
    t.binary "data", :limit => 2147483647
  end

  create_table "followers", :force => true do |t|
    t.string   "ublog_name"
    t.integer  "home_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friends", :force => true do |t|
    t.integer  "home_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "friend_id"
    t.integer  "email_notify"
    t.integer  "is_approved"
  end

  create_table "homes", :force => true do |t|
    t.string   "ublog_name"
    t.string   "owner"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "is_group"
    t.integer  "notify_calendar"
    t.datetime "last_notified"
    t.integer  "asset_id"
    t.integer  "is_private"
    t.string   "proxy"
    t.string   "email_list"
    t.string   "yammer_token"
    t.string   "yammer_secret"
    t.string   "twitter_name"
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.integer  "twitter_last_id", :limit => 8
  end

  add_index "homes", ["twitter_token"], :name => "twitter_token_index"
  add_index "homes", ["yammer_token"], :name => "yammer_token_index"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "taglinks", :force => true do |t|
    t.integer  "blog_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tagsubs", :force => true do |t|
    t.integer  "home_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "email_notify"
  end

  create_table "uploads", :force => true do |t|
    t.string   "filename"
    t.string   "content_type"
    t.integer  "size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "parent_id"
    t.string   "thumbnail"
    t.integer  "blog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
