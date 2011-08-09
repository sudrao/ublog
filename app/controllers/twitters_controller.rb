require 'lib/twitter_api'

class TwittersController < ApplicationController
  before_filter :set_visitor_home
  
  # GET /twitter
  # Temporary. To use Twitter API and read janedoe account
#  def show_twitter
#    credentials = TwitterAPI::Base.get_yaml_credentials
#    access = TwitterAPI::Access.new(credentials)
#    access.read_new_messages
#    flash[:notice] = "Hello"
#    render :text => access.make_html
#  end
  
  # GET /twitter
  def show
    @twitter = true
    render :template => "yammers/show.html.erb"
  end
  
  # GET /twitter/new
  def new
    @twitter = true
    begin
      credentials = TwitterAPI::Base.get_yaml_credentials
      req = TwitterAPI::Request.new(credentials)
      @link = req.authorize_url
      # Save request token essentials to use during create
      session[:rtoken] = req.request_token.token
      session[:rsecret] = req.request_token.secret
      render :template => "yammers/new.html.erb"
    rescue
      flash[:error] = $!
      render :template => "yammers/show.html.erb"
    end
  end

  # POST /twitter
  # Create and save new credentials for this user
  def create
    @twitter = true
    begin
      credentials = TwitterAPI::Base.get_yaml_credentials
      # Recreate consumer and request token that was used in new action
      req = TwitterAPI::Request.new(credentials, session[:rtoken], session[:rsecret])
      # Now verify with Twitter and get the final access token for user
      @result = "Congratulations - cross-posting with Twitter is now set up!"
      begin
        access_token = req.verify(params[:verifier])
        # save for next time
        @visitor_home.twitter_token = access_token.token
        @visitor_home.twitter_secret = access_token.secret
        @visitor_home.twitter_name = params[:twitter_name]
        if @visitor_home.save
          redirect_to :action => 'show'
        else
          @result = "ublog login or database error - Twitter setup failed."
          render :template => "yammers/create.html.erb"
        end
      rescue
        @result = "Twitter authorization failed! Your verification code was not accepted: " + $!
        render :template => "yammers/create.html.erb"
      end
    rescue
      flash[:error] = $!
      @result = "We're sorry but something went wrong."
      render :template => "yammers/create.html.erb"
    end
  end
  
  # DELETE /twitter
  # Remove credentials
  def destroy
    @visitor_home.update_attributes(:twitter_name => nil, :twitter_token => nil, :twitter_secret => nil)
    redirect_to :action => 'show'
  end
end
