class CreateTaglinks < ActiveRecord::Migration
  def self.up
    create_table :taglinks do |t|
      t.integer :blog_id
      t.integer :tag_id

      t.timestamps
    end
  end

  def self.down
    drop_table :taglinks
  end
end
