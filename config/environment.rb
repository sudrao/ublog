# Load the rails application
require File.expand_path('../application', __FILE__)

# Change globals to whatever you need
DOMAIN = 'test'

# Initialize the rails application
Ublog::Application.initialize!
