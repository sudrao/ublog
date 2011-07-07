class TestLdap < ActiveRecord::Base
  require 'rubygems'
  require 'net/ldap'
  
  def self.test
    ldap = Net::LDAP.new
    level = 'ds' # dev or stage or ds
    ldap.host = "#{level}.cisco.com"
    ldap.port = 3268
#    ldap.auth("crbuadam.gen@#{level}.cisco.com", 'crbuquality')
    ldap.auth("crbuadam.gen@cisco.com", 'crbuquality')
    unless ldap.bind
      puts 'Bind failed'
      return
    end
    userid = 'sudrao'
    server = "DC=#{level}," # Change to dev, stage or remove for prod
    server = ''
    
    puts "Going to search #{ldap.host} for #{userid} now"
#    filter = Net::LDAP::Filter.pres( "objectclass" )
    treebase = "CN=#{userid}, OU=employees, OU=Cisco Users, #{server} DC=cisco, DC=com"
    manager = ""
    ldap.search( :base => treebase, :attributes => 'manager') do |entry|
#       puts "DN: #{entry.dn}"
       entry.each do |attribute, values|
       # We expect two pairs: manager,value and dn, value
       # where dn is the matching entry
       # The value is a string which looks like this:
       # CN=jprovine,OU=Employees,OU=Cisco Users,DC=dev,DC=cisco,DC=com
       # The CN value is the manager id
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
#      conn.search("CN=sudrao, OU=employees, OU=Cisco Users, DC=cisco, DC=com",
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
