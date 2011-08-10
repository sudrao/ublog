#ENV['RAILS_ENV']  = (ENV['RAILS_ENV'] || 'development').dup
# RAILS_ROOT isn't defined yet, so figure it out.
require "uri"
require "fileutils"
require "yaml"
dir = File.dirname(__FILE__)
SOLR_PATH = File.expand_path("#{dir}/../solr") unless defined? SOLR_PATH

#RAILS_ROOT = File.expand_path("#{File.dirname(__FILE__)}/../test") unless defined? RAILS_ROOT
unless defined? SOLR_LOGS_PATH
  SOLR_LOGS_PATH = ENV["SOLR_LOGS_PATH"] || ::Rails.root.join("log")
end
unless defined? SOLR_PIDS_PATH
  SOLR_PIDS_PATH = ENV["SOLR_PIDS_PATH"] || ::Rails.root.join("tmp", "pids")
end
unless defined? SOLR_DATA_PATH
  SOLR_DATA_PATH = ENV["SOLR_DATA_PATH"] || ::Rails.root.join("solr", "#{Rails.env}")
end
unless defined? SOLR_CONFIG_PATH
  SOLR_CONFIG_PATH = ENV["SOLR_CONFIG_PATH"] || "#{SOLR_PATH}/solr"
end

unless defined? SOLR_PORT
  config = YAML::load_file(Rails.root.join('config', 'solr.yml'))
  raise("No solr environment defined for RAILS_ENV the #{Rails.env.inspect}") unless config[Rails.env]
  SOLR_PORT = ENV['PORT'] || URI.parse(config[Rails.env]['url']).port
end

SOLR_JVM_OPTIONS = config[Rails.env]['jvm_options'] unless defined? SOLR_JVM_OPTIONS

if ENV["ACTS_AS_SOLR_TEST"]
  require "activerecord"
  DB = (ENV['DB'] ? ENV['DB'] : 'sqlite') unless defined?(DB)
  MYSQL_USER = (ENV['MYSQL_USER'].nil? ? 'root' : ENV['MYSQL_USER']) unless defined? MYSQL_USER
  require File.join(File.dirname(File.expand_path(__FILE__)), '..', 'test', 'db', 'connections', DB, 'connection.rb')
end