class AddToToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :to, :integer
  end

  def self.down
    remove_column :blogs, :to
  end
end
