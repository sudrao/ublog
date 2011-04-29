class AddYammerToHome < ActiveRecord::Migration
  def self.up
    add_column :homes, :yammer_token, :string
    add_column :homes, :yammer_secret, :string
  end

  def self.down
    remove_column :homes, :yammer_secret
    remove_column :homes, :yammer_token
  end
end
