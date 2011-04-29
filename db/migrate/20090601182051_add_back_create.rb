class AddBackCreate < ActiveRecord::Migration
  def self.up
    add_index   'blogs', 'created_at', :name => "created_index"
  end

  def self.down
    remove_index 'blogs', :name => "created_index"
  end
end
