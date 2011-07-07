require "spec_helper"

describe "tags within blogs" do
  # Note we are testing two models here:
  # tags and taglinks as they are related.

  before(:each) do
    @blog = Blog.make!(:with_tag)
    tags = @blog.taglist
    @tag = tags[0]
  end  

  it "creates a tag when a blog has a new tag" do
    Tag.create(:name => @tag).should have(:no).errors
  end
  
  it "validates uniqueness of tag" do
    t1 = Tag.create(:name => @tag)
    Tag.create(:name => @tag).should have(1).error_on(:name)
  end
  
  it "links a blog to its tag" do
    t = Tag.create(:name => @tag)
    link = Taglink.new
    link.blog = @blog
    link.tag = t
    link.save.should be_true
  end
end