class AddPrivateToHome < ActiveRecord::Migration
  def self.up
    add_column :homes, :is_private, :integer
  end

  def self.down
    remove_column :homes, :is_private
  end
end
