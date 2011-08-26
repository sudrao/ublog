# Module for Yammer API access
require 'oauth_mod'
require 'yaml'

module YammerAPI
class Base < OauthMod::Base
    
  def initialize(consumer_key, consumer_secret)
    super(consumer_key, consumer_secret, "https://www.yammer.com")
  end
  
  # Helper to read YAML and returns this hash:
  #  credentials = {
  # :consumer_key => consumer.key,
  # :consumer_secret => consumer.secret,
  # :access_token => access_token.token,
  # :access_token_secret => access_token.secret
  # }
  def self.get_yaml_credentials(credential_file = "config/yammer_auth.yml")
    YAML.load_file(credential_file)
  end
  
  # Return the response from Yammer after posting a message.
  def post(content)
    post_to("/api/v1/messages/", {:body => content})
  end
  
  # Returns last read id or nil 
  def read_new_messages(last_id=nil)
    newer = ""
    newer = "?newer_than=#{last_id.to_s}" if last_id
    # Get latest 20 messages
    begin
      reply = @access_token.get("/api/v1/messages.xml" + newer)
    
#    File.open("tmp/dump.xml", "w") do |f|
#      f.write reply.body      
#    end
    
    # Parse xml. doc has xml, updates has the messages
      doc, @updates = Hpricot::XML(reply.body), []
    
    # First get the names of users
      @names = {}
      (doc/:reference).each do |ref|
        next unless ref.at('type').innerHTML.include? 'user'
        id = ref.at('id').innerHTML
        @names[id] = ref.at('name').innerHTML
      end
    
    # Then the messages
    last_id = 0
    (doc/:message).each do |msg|
      id = msg.at('id').innerHTML
      last_id = id.to_i if last_id < id.to_i
      from = msg.at('sender-id').innerHTML # get the id
      from = @names[from] if @names[from]  # get name from id
      time = msg.at('created-at').innerHTML
      content= msg.at('body').at('plain').innerHTML
      @updates << {:id => id, :from => from, :content => content, :time => time}
    end
    
    # Show
#    render :text => make_html(updates, names)
    rescue  StandardError, Timeout::Error
      last_id = 0 # Timeouts are very common
    end
    last_id == 0 ? nil : last_id
  end
  
  def self.get_name_from_id(id)
    reply = @access_token.get("/api/v1/users/#{id}.xml")
    user = Hpricot::XML(reply.body)
    name = "default"
    (user/:response).each do |resp|
      name =  resp.at('full-name').innerHTML if name == "default"
    end     
    name
  end
  
end

# This class is used to access Yammer as a pre-authorized consumer (ublog app or user)
class Access < YammerAPI::Base
  include OauthMod::Access
end
  
# This class is used to access Yammer as a new user who needs authorization
class Request < YammerAPI::Base
  include OauthMod::Request
end    
  
end
