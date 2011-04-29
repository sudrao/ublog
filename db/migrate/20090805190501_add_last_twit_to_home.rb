class AddLastTwitToHome < ActiveRecord::Migration
  def self.up
    add_column :homes, :twitter_last_id, :integer
    add_index "homes", ["twitter_token"], :name => "twitter_token_index"
    add_index "homes", ["yammer_token"], :name => "yammer_token_index"
  end

  def self.down
    remove_index "homes", :name => "yammer_token_index"
    remove_index "homes", :name => "twitter_token_index"
    remove_column :homes, :twitter_last_id
  end
end
