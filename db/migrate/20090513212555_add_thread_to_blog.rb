class AddThreadToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :thread, :integer
  end

  def self.down
    remove_column :blogs, :thread
  end
end
