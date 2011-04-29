class AddEmailToFriend < ActiveRecord::Migration
  def self.up
    add_column :friends, :email_notify, :integer
  end

  def self.down
    remove_column :friends, :email_notify
  end
end
