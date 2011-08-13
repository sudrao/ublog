Given /^I am not logged in$/ do
  pending # express the regexp above with the code you wish you had
end

Given /^I am logged in$/ do
  pending # express the regexp above with the code you wish you had
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

Then /^when I enter my credentials$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see the following homes:$/ do |expected_homes_table|
  expected_homes_table.diff!(tableish('table tr', 'td,th'))
end
