class AddPrivateToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :is_private, :integer
  end

  def self.down
    remove_column :blogs, :is_private
  end
end
