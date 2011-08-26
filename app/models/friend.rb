class Friend < ActiveRecord::Base
  # Cannot friend self
  validate :not_self
  # Cannot friend the same person twice
  validates :friend_id, :uniqueness => {:scope => :"home_id"}
  # origin is the person (account) who clicked "Follow"
  belongs_to :origin, :class_name => "Home", :foreign_key => "home_id"
  # friend_home is the account that is being followed
  belongs_to :friend_home, :class_name => "Home", :foreign_key => "friend_id"
  
  private
  def not_self
    if (friend_id == home_id)
      errors.add(:friend_id, "You cannot follow yourself")
    end
  end
end
