class Upload < ActiveRecord::Base
#TODO  has_attachment :content_type => ['application/pdf', 'application/msword', 
#    'application/mspowerpoint', 'application/msexcel', 'text/plain', 
#    'application/vnd.ms-excel', 
#   'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
#    'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
#    'application/vnd.ms-powerpoint',
#    'application/vnd.openxmlformats-officedocument.presentationml.presentation',
#    :image],
#    :max_size => 5.megabytes,
#    :thumbnails => { :thumb => [50, 50], :geometry => 'x50' },
#    :storage => "file_system",
#    :processor => "MiniMagick"

#  validates_as_attachment
  belongs_to :blog
  
  def is_image
    content_type.index 'image'
  end
end
