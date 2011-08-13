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

When /^I delete the (\d+)(?:st|nd|rd|th) home$/ do |pos|
  visit homes_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following homes:$/ do |expected_homes_table|
  expected_homes_table.diff!(tableish('table tr', 'td,th'))
end
