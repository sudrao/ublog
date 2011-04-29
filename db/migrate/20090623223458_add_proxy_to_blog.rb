class AddProxyToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :proxy, :string
  end

  def self.down
    remove_column :blogs, :proxy
  end
end
