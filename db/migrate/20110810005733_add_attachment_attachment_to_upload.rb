class AddAttachmentAttachmentToUpload < ActiveRecord::Migration
  def self.up
    add_column :uploads, :attachment_file_name, :string
    add_column :uploads, :attachment_content_type, :string
    add_column :uploads, :attachment_file_size, :integer
    add_column :uploads, :attachment_updated_at, :datetime
    remove_column :uploads, :filename
    remove_column :uploads, :content_type
    remove_column :uploads, :size
    remove_column :uploads, :width
    remove_column :uploads, :height
    remove_column :uploads, :parent_id
    remove_column :uploads, :thumbnail
    
  end

  def self.down
    remove_column :uploads, :attachment_file_name
    remove_column :uploads, :attachment_content_type
    remove_column :uploads, :attachment_file_size
    remove_column :uploads, :attachment_updated_at
    add_column :uploads, :filename, :string
    add_column :uploads, :content_type, :string
    add_column :uploads, :size, :integer
    add_column :uploads, :width, :integer
    add_column :uploads, :height, :integer
    add_column :upooads, :parent_id, :integer
    add_column :uploads, :thumbnail, :string
  end
end
