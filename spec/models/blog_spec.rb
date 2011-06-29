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
      h = Home.create(:ublog_name => "johndoe", :name => "John Doe",
        :asset_id => 10, :owner => "someone")
      h.blogs.create(:content => "Howdy!").should have(:no).errors
    end
end