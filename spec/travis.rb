#!/usr/bin/env ruby
path = File.absolute_path(__FILE__)

if ENV['TRAVIS']
  system "cp #{path}/travis.yml config/database.yml"
  system "mysql -e 'create database ublog_test;' >/dev/null"
  abort "failed to create mysql database" unless $?.success?
  system "bundle exec rake db:schema:load"
end

ENV['DB'] = 'mysql'
exit 1 unless system "bundle exec rake spec"

