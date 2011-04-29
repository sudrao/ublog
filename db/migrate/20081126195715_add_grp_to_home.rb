class AddGrpToHome < ActiveRecord::Migration
  def self.up
    add_column :homes, :is_group, :integer
  end

  def self.down
    remove_column :homes, :is_group
  end
end
