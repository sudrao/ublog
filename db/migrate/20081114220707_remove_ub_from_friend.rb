class RemoveUbFromFriend < ActiveRecord::Migration
  def self.up
    remove_column :friends, :ublog_name
  end

  def self.down
    add_column :friends, :ublog_name, :string
  end
end
