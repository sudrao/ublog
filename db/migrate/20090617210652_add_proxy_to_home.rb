class AddProxyToHome < ActiveRecord::Migration
  def self.up
    add_column :homes, :proxy, :string
  end

  def self.down
    remove_column :homes, :proxy
  end
end
