class Asset < ActiveRecord::Base
#TODO Put back attachments when we have the right plugin TODO
#  has_attachment  :storage => :db_file,
#                  :content_type => :image,
#                  :resize_to => '200',
#                  :max_size => 3.megabytes,
#                  :thumbnails => { :thumb => [50, 50], :geometry => 'x50' },
#                  :processor => 'MiniMagick'

#  validates_as_attachment
  
  belongs_to :home
end
