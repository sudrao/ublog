class AddHomeIndexToBlog < ActiveRecord::Migration
  def self.up
    remove_index 'blogs', :name => "created_index"
    add_index   'blogs', 'home_id', :name => "home_index"
    add_index   'blogs', 'to_id', :name => "to_index"
  end

  def self.down
    add_index   'blogs', 'created_at', :name => "created_index"
    remove_index 'blogs', :name => "home_index"
    remove_index 'blogs', :name => "to_index"
  end
end
