class AddNameToHome < ActiveRecord::Migration
  def self.up
    add_column :homes, :name, :string
  end

  def self.down
    remove_column :homes, :name
  end
end
