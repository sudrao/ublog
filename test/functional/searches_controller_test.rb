require 'test_helper'

class SearchesControllerTest < ActionController::TestCase
  def test_create_search
    post :create, {:query => 'test*'}, {:user => '#{TESTUSER}'} # search for ublog_names starting with test
    assert assigns(:homes)
    assert_response :success
  end
end
