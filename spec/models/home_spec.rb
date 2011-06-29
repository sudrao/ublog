require "spec_helper"

describe Home do
    it "fails validation without ublog_name" do
      Home.create.should have(1).error_on(:ublog_name)
    end
    
    it "fails validation with bad ublog_name" do
      Home.create(:ublog_name => "Doe, John").should have(1).error_on(:ublog_name)
    end
    
    it "fails validation without name" do
      Home.create.should have(1).error_on(:name)
    end
    
    it "fails validation without owner" do
      Home.create.should have(1).error_on(:owner)
    end
  
    it "fails validation with bad email_list" do
      Home.create(:email_list => "aaa@bbb.com").should have(1).error_on(:email_list)
    end
    
    it "passes validation with good input" do
      h = Home.create(:ublog_name => "johndoe", :name => "John Doe",
        :asset_id => 10, :owner => "someone").should have(:no).errors
    end
end