class CreateTagsubs < ActiveRecord::Migration
  def self.up
    create_table :tagsubs do |t|
      t.integer :home_id
      t.integer :tag_id

      t.timestamps
    end
  end

  def self.down
    drop_table :tagsubs
  end
end
