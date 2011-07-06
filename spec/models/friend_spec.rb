require "spec_helper"

describe Friend do
  before(:each) do
    @h1 = Home.make!
    @h2 = Home.make!    
  end

  it "fails validation if friending self" do
    @h1.friends.create(:friend_id => @h1.id).should have(1).error
  end
    
  it "passes validation with good input" do
     @h1.friends.create(:friend_id => @h2.id).should have(:no).errors
  end

  it "fails validation if friending someone twice" do
    @h1.friends.create(:friend_id => @h2.id)
    @h1.friends.create(:friend_id => @h2.id).should have(1).error
  end
end