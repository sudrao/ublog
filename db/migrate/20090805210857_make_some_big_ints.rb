class MakeSomeBigInts < ActiveRecord::Migration
  def self.up
    change_column :homes, :twitter_last_id, :integer, :limit => 8
    change_column :cross_posts, :yammer_last_id, :integer, :limit => 8
  end

  def self.down
    change_column :homes, :twitter_last_id, :integer
    change_column :cross_posts, :yammer_last_id, :integer
  end
end
