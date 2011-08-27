class Upload < ActiveRecord::Base
  has_attached_file :attachment, :styles => { :thumb => "50x50>" },
                    :url => "/uploads/uploads/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/uploads/uploads/:id/:style/:basename.:extension"
                  
  validates_attachment_presence :attachment
  validates_attachment_size :attachment, :less_than => 5.megabytes
  validates_attachment_content_type :attachment,
   :content_type => ['application/pdf', 'application/msword', 
     'application/mspowerpoint', 'application/msexcel', 'text/plain', 
     'application/vnd.ms-excel', 
     'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
     'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
     'application/vnd.ms-powerpoint',
     'application/vnd.openxmlformats-officedocument.presentationml.presentation',
     'image/jpeg', 'image/png']
     
  belongs_to :blog
  
  def is_image
    attachment.content_type.index 'image'
  end
end
