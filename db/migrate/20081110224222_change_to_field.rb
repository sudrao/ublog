class ChangeToField < ActiveRecord::Migration
  def self.up
    rename_column :blogs, :to, :to_id
  end

  def self.down
    rename_column :blogs, :to_id, :to
  end
end
