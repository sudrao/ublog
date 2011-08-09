# Load the rails application
require File.expand_path('../application', __FILE__)

# Change these to whatever you need
SOLR_PATH='/Users/sudhir/apps/apache-solr-3.3.0/example'
TESTUSER = 'TEST'
DOMAIN = 'test'

# Initialize the rails application
Ub3::Application.initialize!
