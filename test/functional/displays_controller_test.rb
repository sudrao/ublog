require 'test_helper'

class DisplaysControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  def test_create_display
    post :create, { :home_id => homes(:one).id, :page => 2 }, {:user => '#{TESTUSER}' }
    assert_response :success
  end
end
