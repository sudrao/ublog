class AddTwitterToHome < ActiveRecord::Migration
  def self.up
    add_column :homes, :twitter_name, :string
    add_column :homes, :twitter_token, :string
    add_column :homes, :twitter_secret, :string
  end

  def self.down
    remove_column :homes, :twitter_secret
    remove_column :homes, :twitter_token
    remove_column :homes, :twitter_name
  end
end
