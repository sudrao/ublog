require 'test_helper'

class BlogTest < ActiveSupport::TestCase
  def test_create
    blog = Blog.new(:content => "something",
                    :home_id => 5,
                    :to_id => 7)
    assert blog.valid?
    # No content
    blog = Blog.new(:home_id => 5,
                    :to_id => 7)
    assert !blog.valid?
    assert blog.errors.invalid?(:content)
  end
  
  def test_mine
    blogs = Blog.mine(2, false, Home.find(1), 25, 0) # my id = 2, not owner, visiting 1
    paginate = blogs.length > 25
    assert blogs.length == 4
    assert !paginate
  end
end
