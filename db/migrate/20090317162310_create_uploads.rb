class CreateUploads < ActiveRecord::Migration
  def self.up
    create_table :uploads do |t|
      t.string :filename
      t.string :content_type
      t.integer :size
      t.integer :width
      t.integer :height
      t.integer :parent_id
      t.string :thumbnail
      t.integer :blog_id

      t.timestamps
    end
  end

  def self.down
    drop_table :uploads
  end
end
