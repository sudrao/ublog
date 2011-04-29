class AddEmailToTagsub < ActiveRecord::Migration
  def self.up
    add_column :tagsubs, :email_notify, :integer
  end

  def self.down
    remove_column :tagsubs, :email_notify
  end
end
