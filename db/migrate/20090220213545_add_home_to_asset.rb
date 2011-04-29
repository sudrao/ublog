class AddHomeToAsset < ActiveRecord::Migration
  def self.up
    add_column :assets, :home_id, :integer
  end

  def self.down
    remove_column :assets, :home_id
  end
end
