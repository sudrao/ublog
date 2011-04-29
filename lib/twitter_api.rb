# Module for Twitter REST API access
require 'oauth_mod'
require 'yaml'

module TwitterAPI
class Base < OauthMod::Base
    
  def initialize(consumer_key, consumer_secret)
    super(consumer_key, consumer_secret, "http://twitter.com")
  end
  
  # Helper to read YAML and returns this hash:
  #  credentials = {
  # :consumer_key => consumer.key,
  # :consumer_secret => consumer.secret,
  # :access_token => access_token.token, # not used
  # :access_token_secret => access_token.secret # not used
  # }
  def self.get_yaml_credentials(credential_file = "config/twitter_auth.yml")
    YAML.load_file(credential_file)
  end
  
  # Return the response from Twitter after posting a message
  def post(content)
    post_to("/statuses/update.xml", {:status => content})
  end
  
  # Returns last read id or nil 
  def read_new_messages(last_id=nil)
    newer = ""
    newer = "?since_id=#{last_id.to_s}" if last_id
    # Get latest 20 messages
    begin
      reply = @access_token.get("/statuses/user_timeline.xml" + newer)
    
#    File.open("tmp/dump.xml", "w") do |f|
#      f.write reply.body      
#    end
    
    # Parse xml. doc has xml, updates has the messages
      doc, @updates = Hpricot::XML(reply.body), []
    # Extract updates from XML
    last_id = 0
    (doc/:status).each do |msg|
      id = msg.at('id').innerHTML
      last_id = id.to_i if last_id < id.to_i
      from = msg.at('user/screen_name').innerHTML
      time = msg.at('created_at').innerHTML
      content= msg.at('text').innerHTML
      @updates << {:id => id, :from => from, :content => content, :time => time}
    end
    
    # Show
#    render :text => make_html(updates, names)
    rescue  StandardError, Timeout::Error
      last_id = 0 # Timeouts are very common
    end
    last_id == 0 ? nil : last_id
  end
    
end

# This class is used to access Twitter as a pre-authorized consumer (ublog app or user)
class Access < TwitterAPI::Base
  include OauthMod::Access
end
  
# This class is used to access Twitter as a new user who needs authorization
class Request < TwitterAPI::Base
  include OauthMod::Request
end    
  
end
