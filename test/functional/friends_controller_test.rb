require 'test_helper'

class FriendsControllerTest < ActionController::TestCase
  def test_should_create_friend
    assert_difference('Friend.count') do
      post :create, {:friend => {:home_id => 2, :friend_id => 1 }}, {:user => '#{TESTUSER}' }
    end
    assert assigns(:friend)
    assert_redirected_to home_path(assigns(:return_home))
  end

  def test_should_destroy_friend
    assert_difference('Friend.count', -1) do
      delete :destroy, {:id => friends(:one).id}, {:user => '#{TESTUSER}'}
    end

    assert_redirected_to home_path(assigns(:return_home))
  end
end
