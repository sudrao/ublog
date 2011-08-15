Given /^I am not logged in$/ do
  # Clear cookies. Database already cleaned
  reset!
end

When /^I enter my credentials$/ do
  my_log_in(TEST1, SECRET1)
  visit path_to("home")
end

Given /^I am logged in$/ do
  visit session_path
  When 'I enter my credentials'
end

Given /^the following homes:$/ do |homes|
  Home.create!(homes.hashes)
end

When /^(?:|I )follow that user$/ do
  click_button "Follow this account"
end

Then /^(?:|I )should see a following count of (\d+)$/ do |friend_count|
  page.should have_xpath("//div[@id='friends']/a", :text => "#{friend_count}") # match number of friends
end

Then /^I should see that user's name$/ do
  page.should have_content(TEST2) # TEST2 is the friend I follow
end

When /^I delete the (\d+)(?:st|nd|rd|th) home$/ do |pos|
  visit homes_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following homes:$/ do |expected_homes_table|
  expected_homes_table.diff!(tableish('table tr', 'td,th'))
end
