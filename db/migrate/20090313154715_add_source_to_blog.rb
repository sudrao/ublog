class AddSourceToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :source, :string
  end

  def self.down
    remove_column :blogs, :source
  end
end
