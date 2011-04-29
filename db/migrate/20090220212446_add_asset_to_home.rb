class AddAssetToHome < ActiveRecord::Migration
  def self.up
    add_column :homes, :asset_id, :integer
  end

  def self.down
    remove_column :homes, :asset_id
  end
end
