require 'test_helper'

class FriendTest < ActiveSupport::TestCase
  def test_create
    friend = Friend.new(:home_id => 3, :friend_id => 5)
    assert friend.valid?
    friend.save
    # Non-dup test
    friend = Friend.new(:home_id => 7, :friend_id => 5)
    assert friend.valid?
    # Dup test
    friend = Friend.new(:home_id => 3, :friend_id => 5)
    assert !friend.valid?
    assert friend.errors.invalid?(:friend_id)
  end
end
