class LdapGet
  require 'rubygems'
  require 'net/ldap'
  
  # Authenticate a user in Company
  def self.auth (userid, password)
    return false if password.blank?
    ldap = Net::LDAP.new
    ldap.host = "ds.#{DOMAIN}.com"
    ldap.port = 3268 # read-only port
    ldap.auth(userid+'@#{DOMAIN}.com', password)
    ldap.bind # bind == TRUE indicates success
  end
  
  # Get first and last name of a user in Company
  def self.name (userid)
    return userid if userid == "#{TESTUSER}"
    ldap = Net::LDAP.new
    ldap.host = "ldap.#{DOMAIN}.com"
    ldap.port = 3268 # read-only port
    ldap.auth("admin@#{DOMAIN}.com", 'admin-password')
    unless ldap.bind
      puts 'Bind failed for generic ldap account'
      return nil
    end
    treebase = "CN=#{userid}, OU=employees, OU=Company Users, DC=#{DOMAIN}, DC=com"
    name = nil
    ldap.search( :base => treebase, :attributes => 'displayname') do |entry|
      entry.each do |attribute, value|
        next unless attribute.to_s.include? 'displayname'
        # We expect only one entry. Process it.
        name = value.to_s 
        name = name[/^.*\(/][0..-2] if name.include? '('
        name = name.chomp(' ') # remove trailing blanks
      end
    end
    return name
  end
end
