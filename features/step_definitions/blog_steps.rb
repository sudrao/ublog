Given /^I post a blog$/ do
  fill_in('blog_content', :with => BLOG1 + Fabricate.sequence(:number).to_s)
  click_button("Update")
end

Then /^I should see my blog(?:| appear)$/ do
  if page.respond_to? :should
    page.should have_content(BLOG1)
  else
    assert page.has_content?(BLOG1)
  end
end
