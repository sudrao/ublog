require "spec_helper"

describe Blog do
    it "fails validation without content" do
      Blog.create.should have(1).error_on(:content)
    end
    
    it "fails validation without home_id" do
      # We have two validations: present and greater than 0
      Blog.create.should have(2).error_on(:home_id)
    end
    
    it "fails validation with bad home_id" do
      Blog.create(:home_id => -1).should have(1).error_on(:home_id)
    end
    
    it "passes validation with good input" do
      h = Home.make! # use factory
      h.blogs.create(:content => "Howdy!").should have(:no).errors
    end
    
    # Create a couple of users. The first follows
    # the second. The second could be private
    # returns both user accounts
    def subscribers(private = 0)
      h = Home.make! # user's home
      group = Home.make!(:is_private => private) # subscribed home
      h.friends.create(:friend_id => group.id, :is_approved => 1) 
      return h, group     
    end

    def make_priv_blogs(home, group, count=1)
      b = Blog.make(count, :home_id => home.id, :to_id => group.id, :is_private => 1) # private
      b.each { |bl| bl.save } # work around machinist inability to save even with make! above
    end
    
    it "returns all blogs in system except private ones", :one => true do
      Blog.make!(5) # non-private
      h, group = subscribers(1)
      h2 = Home.make!
      make_priv_blogs(h2, group, 2)
      make_priv_blogs(h, group, 3)
      Blog.all_blogs(h2).count.should == 7
      Blog.all_blogs(h).count.should == 10 # h also subscribed to group so gets h2 blogs
      b = Blog.all_blogs(h2).each do |bl|
        bl.content.should_not be_nil  # verify we can iterate over results
      end
    end
end