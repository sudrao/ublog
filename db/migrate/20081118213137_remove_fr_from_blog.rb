class RemoveFrFromBlog < ActiveRecord::Migration
  def self.up
    remove_column :blogs, :from
  end

  def self.down
    add_column :blogs, :from, :string
  end
end
