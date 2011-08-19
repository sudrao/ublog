Given /^I post a blog$/ do
  with_scope("update div") do
    fill_in('blog[content]', :with => BLOG1 + Fabricate.sequence(:number).to_s)
    click_button("Update")
  end
end

When /^I click the reply link$/ do
  click_link('reply')
end

Then /^I should see a reply dialog box$/ do
  page.should have_content("Type your reply to")
end

When /^I type in a reply and submit it$/ do
  with_scope("blog_reply div") do
    fill_in('blog[content]', :with => BLOG_REPLY + Fabricate.sequence(:number).to_s)
    click_button("Send")
  end
end

Then /^I should see my reply message$/ do
  page.should have_content(BLOG_REPLY)
end

Then /^I (?:|should )see (my|another user's) blog(?:| appear)$/ do |whose|
  case whose
  when 'my'
    message = BLOG1
  when "another user's"
    message = BLOG2
  end
  if page.respond_to? :should
#    puts page.html
    page.should have_content(message)
  else
    assert page.has_content?(message)
  end
end
