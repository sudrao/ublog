class GetNames < ActiveRecord::Base
  # This is used to debug LdapGet.name
  def self.run
      name = LdapGet.name('jhelvie')
      puts name
  end
end