class DropResponse < ActiveRecord::Migration
  def self.up
    drop_table :responses
  end

  def self.down
    create_table :responses do |t|
      t.string :from
      t.string :content
      t.integer :home_id

      t.timestamps
    end
  end
end
