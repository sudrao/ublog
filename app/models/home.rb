class Home < ActiveRecord::Base
  validates :ublog_name, :presence => true, :uniqueness => true
  validates :ublog_name, :format => {:with => /\A[^ $~!@#%^&*+=(){};':",?<>.]*\Z/, :message => " cannot have blanks or punctuation. Remove them. Check for trailing blanks."}
  validates :owner, :name, :presence => true
  validates :email_list, :format => {:with => /\A[^ $~!@#%^&*+=(){};':",?<>.]*\Z/, :message => " cannot have @ or blanks or punctuation. Remove them. Check for trailing blanks."}
 
  has_attached_file :photo, :styles => {:thumb => "50x50>" , :small => "200x200>" },
                    :url => "assets/homes/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/homes/:id/:style/:basename.:extension"
  validates_attachment_size :photo, :less_than => 5.megabytes
  validates_attachment_content_type :photo, :content_type => ['image/jpeg', 'image/png']
  
  has_many :blogs # as "owner" of those blogs
  has_many :responses, :class_name => "Blog", :foreign_key => "to_id" # blogs "to" this owner
  has_many :friends # as the "origin" of the friendship
  has_many :friend_homes, :through => :friends # refer back to homes
  has_many :followers, :class_name => "Friend", :foreign_key => "friend_id" # "friend_home" matches
  has_many :follower_homes, :through => :followers, :source => :origin # refer back to homes
  has_many :tagsubs
  has_many :tags, :through => :tagsubs
  has_many :groups, :through => :friends, :source => :friend_home, :conditions => "is_group = 1"
  
  # email subscriptions; subset of friend_homes and tags
  has_many :email_friends, :class_name => "Friend", :foreign_key => "home_id", :conditions => "email_notify > 0"
  has_many :email_friend_homes, :through => :email_friends, :source => :friend_home
  has_many :email_tagsubs, :class_name => "Tagsub", :foreign_key => "home_id", :conditions => "email_notify > 0"
  has_many :email_tags, :through => :email_tagsubs, :source => :tag
  
  acts_as_solr :fields => [:ublog_name, :name]
  
  def private_subs
    friend_homes.map do |home|
      home if home.is_private && (home.is_private == 1)
    end
  end
end
