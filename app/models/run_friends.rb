class RunFriends < ActiveRecord::Base
  # This is run using script/runner 'RunFriends.fill'
  # Used only once after friend_id (friend_home) field is added to Friend
  # Gets home_id from Home matching that Friend.ublog_name
  # and sets it in the friend records
  def self.fill
    friends = Friend.find(:all)
    friends.each do |friend|
      home = Home.find_by_ublog_name(friend.ublog_name)
      friend.friend_home = home
      friend.save
    end
  end
end
