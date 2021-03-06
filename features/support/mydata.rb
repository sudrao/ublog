module MyCukeData
  BLOG1 = "This is a test blog "
  BLOG2 = "This is test blog from test2"
  BLOG_REPLY = "This is a reply "
  SECRET1 = 'secret1'
  
  def my_basic_auth(name, password)
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
      page.driver.post current_path
  end
  
  def my_log_in(name, password)
    click_button("Log in")
    my_basic_auth(name, password)
  end
end
World(MyCukeData)

DatabaseCleaner.strategy = :truncation

Before do
  # Have a user already created to act as a second user
  h = Home.create!(:ublog_name => TEST2, :name => TEST2, :owner => TEST2)
  # and a messge from this user
  h.blogs.create!(:content => BLOG2)
end

