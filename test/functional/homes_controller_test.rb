require 'test_helper'

class HomesControllerTest < ActionController::TestCase
  def test_should_get_index
  get :index, {}, {:user => '#{TESTUSER}' }
    assert_not_nil assigns(:homes)
    assert_redirected_to home_path(1)
  end

  def test_should_create_home
    assert_difference('Home.count') do
      post :create, {:home => {:ublog_name => 'test3', :owner => 'test3', :name => 'Test 3' }}, {:user => 'test3'}
    end

    assert_redirected_to home_path(assigns(:home))
  end

  def test_should_show_home
  get :show, { :id => homes(:one).id }, {:user => '#{TESTUSER}' }
    assert_response :success
  end

  def test_should_destroy_home
    assert_difference('Home.count', -1) do
      delete :destroy, { :id => homes(:one).id}, {:user => 'janedoe' }
    end

    assert_redirected_to homes_path
  end
end
