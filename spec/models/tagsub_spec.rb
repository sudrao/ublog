require "spec_helper"

describe Tagsub do
  it "allows a user to subscribe to an existing tag" do
    t = Tag.make!
    h = Home.make!
    sub = Tagsub.create(:home => h, :tag => t).should have(:no).errors
  end
end
