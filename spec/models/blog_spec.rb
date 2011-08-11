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

    def make_blogs(home, count=1, is_private=0, group=nil)
      b = Blog.make(count, :home_id => home.id, :to_id => group.nil? ? nil:group.id, :is_private => is_private)
      b.each { |bl| bl.save } # work around machinist inability to save even with make! above
    end
    
    it "returns all blogs in system except private ones" do
      Blog.make!(5) # non-private
      h, group = subscribers(1)
      h2 = Home.make!
      make_blogs(h2, 2, 1, group) # private by h2
      make_blogs(h, 3, 1, group) # private by h
      Blog.all_blogs(h2).count.should == 7
      Blog.all_blogs(h).count.should == 10 # h also subscribed to group so gets h2 blogs
      b = Blog.all_blogs(h2).each do |bl|
        bl.content.should_not be_nil  # verify we can iterate over results
      end
    end

    def make_more_blogs
      Blog.make!(5) # not mine, not subscribed
      h, g = subscribers(1) # my home and subscribed group
      h2 = Home.make! # another's home
      make_blogs(h, 10) # mine, public
      make_blogs(h, 1, 1, g) # mine, private
      make_blogs(h2, 4, 1, g) # other's private messages to subscribed group
      make_blogs(h2, 5, 0, g) # other's public messages to subscribed group
      g2 = Home.make! # other group
      make_blogs(h2, 7, 0, g2) # other's public messages to unsubscribed group
      make_blogs(h2, 3, 1, g2) # other's private messages to unsubscribed group
      return h, g, h2, g2
    end    
    
    it "returns my blogs", :one => true do
      h, g, h2, g2 = make_more_blogs
      # On my home page
      b = Blog.mine(h.id, true, false, h) # get my blogs and subcribed blogs on my page
      b.count.should == 20
      b.each do |bl|
        bl.content.should_not be_nil
      end
      # Visiting another person's page
      b = Blog.mine(h.id, false, false, h2) # look at other user's page
      b.count.should == 16 # I can only see public blogs of other + private ones I am subscribed to
      # RSS feed from my home page
      b = Blog.mine(h.id, true, true, h) # fake authorization for rss feeds
      b.count.should == 15 # only my public messages
      # Visiting group page as owner
      b = Blog.mine(h.id, true, false, g)
      b.count.should == 10
    end
    
    it "returns my blogs marked for email delivery" do
      h, g, h2, g2 = make_more_blogs
      f = Friend.find_by_home_id(h.id)
      f.email_notify = 1
      f.save
      h.friends.create(:friend_id => h2.id, :email_notify => true) # be friends with h2
      b = Blog.my_email(h.id, 1.minute.ago.utc, Time.now.utc)
      b.count.should == 16
    end
end