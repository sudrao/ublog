source 'http://rubygems.org'

gem 'rails', '3.1.0.rc6'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

gem 'mysql2'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "  ~> 3.1.0.rc"
  gem 'coffee-rails', "~> 3.1.0.rc"
  gem 'uglifier'
end

gem 'jquery-rails'

# app gems
gem 'net-ldap'
gem 'oauth'
gem 'hpricot'
gem 'paperclip'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'

group :test do
  # Pretty printed test output
  # gem 'turn', :require => false
  gem "rspec-rails", "~> 2.6"
  gem 'machinist', '>= 2.0.0.beta2'
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'fabrication'
  gem 'escape_utils' # to suppress rack/utils regexp warning
end
