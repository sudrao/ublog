class AddFromToBlog < ActiveRecord::Migration
  def self.up
    add_column :blogs, :from, :string
  end

  def self.down
    remove_column :blogs, :from
  end
end
