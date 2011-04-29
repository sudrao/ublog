class Friend < ActiveRecord::Base
  validates_uniqueness_of :friend_id, :scope => :"home_id"
  # origin is the person (account) who clicked "Follow"
  belongs_to :origin, :class_name => "Home", :foreign_key => "home_id"
  # friend_home is the account that is being followed
  belongs_to :friend_home, :class_name => "Home", :foreign_key => "friend_id"
end
