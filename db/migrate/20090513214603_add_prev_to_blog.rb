class AddPrevToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :prev_in_thread, :integer
  end

  def self.down
    remove_column :blogs, :prev_in_thread
  end
end
