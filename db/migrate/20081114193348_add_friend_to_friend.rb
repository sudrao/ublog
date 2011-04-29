class AddFriendToFriend < ActiveRecord::Migration
  def self.up
    add_column :friends, :friend_id, :integer
  end

  def self.down
    remove_column :friends, :friend_id
  end
end
