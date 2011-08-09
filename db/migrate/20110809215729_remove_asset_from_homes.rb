class RemoveAssetFromHomes < ActiveRecord::Migration
  def self.up
    remove_column :homes, :asset_id
  end

  def self.down
    add_column :homes, :asset_id, :integer
  end
end
