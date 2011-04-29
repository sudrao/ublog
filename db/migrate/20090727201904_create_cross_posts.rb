class CreateCrossPosts < ActiveRecord::Migration
  def self.up
    create_table :cross_posts do |t|
      t.integer "yammer_last_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :cross_posts
  end
end
