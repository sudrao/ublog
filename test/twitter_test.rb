#!/usr/local/bin/ruby
$LOAD_PATH.unshift( File.join(File.dirname(__FILE__), "../lib") )
require 'rubygems'
require 'twitter_api.rb'

# puts "Please enter your client key, then hit Return."
consumer_key = "SBSlUEoMsrq2DzJ7wlf8Ng" # gets.chomp
#puts "Please enter your client secret, then hit Return."
consumer_secret = "y5v0loEQFBGreitRBlkg5QYKBNr7fedptgnWZzUKJM" #gets.chomp
access_token = "16136597-fYRZwB59OOyCqMTcCCMkEDqpx3OX1q3Pe5XLgCUJq"
access_secret = "vbj4BUE0RvLujX8Lh3vhMLpKjcqwWc4Av1rFyLm6TDQ"

# Use our module
#credentials = {
#  :consumer_key => consumer_key,
#  :consumer_secret => consumer_secret,
#  :access_token => access_token,
#  :access_token_secret => access_secret
#}
credentials = TwitterAPI::Base.get_yaml_credentials
begin
  access = TwitterAPI::Access.new(credentials)
  begin
#    reply = access.read_new_messages
#    puts "Got this last id from your twitter account:"
#    puts reply ? reply.to_s : 'nil'
    reply = access.post("Another two from ublog.")
    puts "Got this after posting:"
    puts reply.body.to_s
  rescue
    puts "Failed to GET/POST: " + $!
  end
rescue
  puts "Couldn't authorize with Twitter. Check client credentials and retry."
  puts $!
end

=begin
begin
  consumer = OAuth::Consumer.new consumer_key, consumer_secret, { :site => "http://twitter.com", :proxy => "http://proxy-sjc-1.#{DOMAIN}.com:8080" }
  access = OAuth::AccessToken.new(consumer, access_token, access_secret)
  begin
#    reply = access.get("/statuses/user_timeline.xml")
#    puts "Got these from your twitter account:"
#    puts reply.body.to_s
#    reply = access.post("/statuses/update.xml", {:status => "Another one from ublog."}, {'Accept' => 'application/xml'})
#    puts "Got this after posting:"
#    puts reply.body.to_s
  rescue
    puts "Failed to GET/POST: " + $!
  end
rescue
  puts "Couldn't authorize with Twitter. Check client credentials and retry."
  puts $!
end
=end
