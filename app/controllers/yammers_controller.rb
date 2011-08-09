require 'lib/yammer_api'

class YammersController < ApplicationController
  before_filter :set_visitor_home
  
  # GET /yammer
  def show
  end
  
  # GET /yammer?new
  def new
    begin
      credentials = YammerAPI::Base.get_yaml_credentials
      req = YammerAPI::Request.new(credentials)
      @link = req.authorize_url
      # Save request token essentials to use during create
      session[:rtoken] = req.request_token.token
      session[:rsecret] = req.request_token.secret
    rescue
      flash[:error] = $!
      render :action => 'show'
    end
  end

  # POST /yammer
  # Create and save new credentials for this user
  def create
    begin
      credentials = YammerAPI::Base.get_yaml_credentials
      req = YammerAPI::Request.new(credentials, session[:rtoken], session[:rsecret])
      # Change the request token parameters to match previous
      # incarnation. The verifier has to match that token
#      req.request_token.token = session[:rtoken]
#      req.request_token.secret = session[:rsecret]
      # Now verify with Yammer and get the final access token for user
      @result = "Congratulations - cross-posting with Yammer is now set up!"
      begin
        access_token = req.verify(params[:verifier])
        # save for next time
        @visitor_home.yammer_token = access_token.token
        @visitor_home.yammer_secret = access_token.secret
        if @visitor_home.save
          redirect_to :action => 'show'
        else
          @result = "ublog login or database error - Yammer setup failed."
        end
      rescue
        @result = "Yammer authorization failed! Your verification code was not accepted."
      end
    rescue
      flash[:error] = $!
      @result = "We're sorry but something went wrong."
    end
  end
  
  # DELETE /yammer
  # Remove credentials
  def destroy
    @visitor_home.update_attributes(:yammer_token => nil, :yammer_secret => nil)
    redirect_to :action => 'show'
  end
end