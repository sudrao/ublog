Given /^I am not logged in$/ do
  # Clear cookies. Database already cleaned
  reset!
end

When /^I enter my credentials$/ do
  fill_in('username', :with => TEST1)
  fill_in('password', :with => SECRET1)
  click_button('Log in')
  visit path_to("home")
end

Given /^I am logged in$/ do
  visit session_path
  When 'I enter my credentials'
end

Given /^(?:|I )log in via URL$/ do
  Capybara.app_host = "http://#{TEST1}:#{SECRET1}@127.0.0.1:3001"
  driver = Selenium::Webdriver.for(page.driver.options[:browser])
  visit session_path
  click_button "Log in"
  visit path_to("home")
end

Given /^the following homes:$/ do |homes|
  Home.create!(homes.hashes)
end

Given /^I have subscribed to another user$/ do
    Given "I go to another user's page"
    When 'I follow that user'
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
