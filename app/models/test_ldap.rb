class TestLdap < ActiveRecord::Base
  require 'rubygems'
  require 'net/ldap'
  
  def self.test
    ldap = Net::LDAP.new
    level = 'ldap' # server
    ldap.host = "#{level}.#{DOMAIN}.com"
    ldap.port = 3268
    ldap.auth("admin@#{DOMAIN}.com", 'admin-password')
    unless ldap.bind
      puts 'Bind failed'
      return
    end
    userid = 'johndoe'
    server = "DC=#{level}," 
    server = ''
    
    puts "Going to search #{ldap.host} for #{userid} now"
    treebase = "CN=#{userid}, OU=employees, OU=Company Users, #{server} DC=#{DOMAIN}, DC=com"
    manager = ""
    ldap.search( :base => treebase, :attributes => 'manager') do |entry|
#       puts "DN: #{entry.dn}"
       entry.each do |attribute, values|
       # We expect two pairs: manager,value and dn, value
       # where dn is the matching entry
#         puts "   #{attribute}:"
         if attribute.to_s.include? 'manager'
           values.each do |value| 
#           puts "      --->#{value}"
             manager = value[/CN=.*?,/][3..-2]
           end
         end
       end
       break
     end
     if ldap.get_operation_result.code == 0
       puts userid+"\'s manager is "+manager
     else  
       p ldap.get_operation_result
     end
#    begin
#      conn.search("CN=janedoe, OU=employees, OU=Company Users, DC=#{DOMAIN}, DC=com",
#                  LDAP::LDAP_SCOPE_BASE,
#                  "(objectclass=*)", ["Manager"]){|e|
#        puts e.vals("cn")
#        puts e.to_hash()
#      }
#    rescue LDAP::ResultError => msg
#      puts msg.to_s
#    end
  end
end
