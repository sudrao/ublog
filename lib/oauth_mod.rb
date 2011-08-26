# Module for oauth access
require 'oauth/consumer'
require 'hpricot'

module OauthMod
class Base
  attr_reader :names, :updates
  attr_reader :access_token
  attr_reader :consumer
  attr_accessor :proxy
  
  # Set proxy to nil before instantiating, if there is no proxy. Not tested
  @@proxy = "http://proxy-sjc-1.cisco.com:8080"
  
  def initialize(consumer_key, consumer_secret, site)
    @consumer = OAuth::Consumer.new(consumer_key, consumer_secret,
      {:site => site, :proxy => @@proxy})
  end
  
  # Return the response from site.
  def post_to(site, content_hash)
  @access_token.post(site, content_hash, 
    {'Accept' => 'application/xml'})
  end
  
  # @updates must be set up before calling this
  def make_html
    out = "<html>\n"
    @updates.each do |u|
      out << u[:id] + ": "
      out << u[:from] + " "
      out << u[:content] + "--- "
      out << u[:time] + "<br><br>\n"      
    end
    out << "</html>\n"
  end
end

# Include Access module in a sub-class of class containing OauthMod::Base
module Access
  def initialize(credentials)
    super(credentials[:consumer_key], credentials[:consumer_secret])
    @access_token = OAuth::AccessToken.new(@consumer, credentials[:access_token], credentials[:access_token_secret])
  end
end
  
# Include Access module in a sub-class of class containing OauthMod::Base
module Request
  attr_reader :authorize_url
  attr_reader :request_token
  
  # After Access.new, you need to complete verify for further access
  # Access.new returns the URL for the user to go to
  # Pass in old request token/secret if recreating a request token
  def initialize(credentials, req_token=nil, req_secret=nil)
    super(credentials[:consumer_key], credentials[:consumer_secret])
    if (req_token && req_secret)
      @request_token = OAuth::RequestToken.new(@consumer, req_token, req_secret)
    else
      @request_token = @consumer.get_request_token
    end
    @authorize_url = @request_token.authorize_url
  end
  
  # Pass in the verifier code that was obtained by the user
  # After this, save credentials (@access_token.token, @access_token.secret) for next time
  def verify(verifier)
    @access_token = @request_token.get_access_token(:oauth_verifier => verifier)
  end
end    
  
end
