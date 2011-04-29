class AddListToHome < ActiveRecord::Migration
  def self.up
    add_column :homes, :email_list, :string
  end

  def self.down
    remove_column :homes, :email_list
  end
end
