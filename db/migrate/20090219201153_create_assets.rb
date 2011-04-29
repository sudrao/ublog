class CreateAssets < ActiveRecord::Migration
  def self.up
    create_table :assets do |t|
      t.string :filename
      t.string :content_type
      t.integer :size
      t.integer :width
      t.integer :height
      t.integer :parent_id
      t.string :thumbnail
      t.integer :db_file_id

      t.timestamps
    end
    create_table :db_files do |t|
      
    end
    execute 'ALTER TABLE db_files ADD COLUMN data LONGBLOB'

  end

  def self.down
    drop_table :db_files
    drop_table :assets
  end
end
