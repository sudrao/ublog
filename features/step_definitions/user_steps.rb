Given /^I am not logged in$/ do
  # nothing to do for this
end

Given /^I am logged in$/ do
  visit session_path
  click_button("Log in")
  # Auth dance with Capybara
  name = 'test1'
  password = 'secret1'
  if page.driver.respond_to?(:basic_auth)
    page.driver.basic_auth(name, password)
  elsif page.driver.respond_to?(:basic_authorize)
    page.driver.basic_authorize(name, password)
  elsif page.driver.respond_to?(:browser) && page.driver.browser.respond_to?(:basic_authorize)
    page.driver.browser.basic_authorize(name, password)
  else
    raise "I don't know how to log in!"
  end
  # Now actually send the basic auth
  page.driver.post session_path # respond to the 401 for initial post
  # Finish up with creating user's home
  visit path_to("home") # first visit will create it
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

When /^I enter my credentials$/ do
  pending # express the regexp above with the code you wish you had
end

Then /^I should see the following homes:$/ do |expected_homes_table|
  expected_homes_table.diff!(tableish('table tr', 'td,th'))
end
