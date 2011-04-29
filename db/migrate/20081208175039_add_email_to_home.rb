class AddEmailToHome < ActiveRecord::Migration
  def self.up
    add_column :homes, :notify, :integer
    add_column :homes, :last_notified, :datetime
  end

  def self.down
    remove_column :homes, :last_notified
    remove_column :homes, :notify
  end
end
