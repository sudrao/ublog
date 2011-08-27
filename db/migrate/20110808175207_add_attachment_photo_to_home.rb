class AddAttachmentPhotoToHome < ActiveRecord::Migration
  def change
    add_column :homes, :photo_file_name, :string
    add_column :homes, :photo_content_type, :string
    add_column :homes, :photo_file_size, :integer
    add_column :homes, :photo_updated_at, :datetime
  end

end
