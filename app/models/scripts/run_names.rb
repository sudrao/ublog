class RunNames < ActiveRecord::Base
  # This is run using script/runner 'RunNames.fill'
  # Used only once after name field is added to Home
  # Gets display names from ldap server for each user
  # and sets it in the homes for each account
  def self.fill
    homes = Home.find(:all)
    homes.each do |home|
      home.name = LdapGet.name(home.owner)
      home.save
    end
  end
end