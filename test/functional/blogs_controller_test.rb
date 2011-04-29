require 'test_helper'

class BlogsControllerTest < ActionController::TestCase
  def test_should_create_blog
    assert_difference('Blog.count') do
      post :create, { :blog => {:content => 'This is content',
                              :home_id => 1,
                              :to_id => 0 }},
                    { :user => '#{TESTUSER}' } # This additional hash stores :user in session
    end

    assert_redirected_to home_path(1)
  end

  def test_should_destroy_blog
    assert_difference('Blog.count', -1) do
      delete :destroy, {:id => blogs(:one).id}, {:user => '#{TESTUSER}' }
    end

    assert_redirected_to blogs_path
  end
end
