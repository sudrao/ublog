class RemoveAssetFromHomes < ActiveRecord::Migration
  def up
    remove_column :homes, :asset_id
  end

  def down
    add_column :homes, :asset_id, :integer
  end
end
