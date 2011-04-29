class AddPrivateToFriend < ActiveRecord::Migration
  def self.up
    add_column :friends, :is_approved, :integer
  end

  def self.down
    remove_column :friends, :is_approved
  end
end
