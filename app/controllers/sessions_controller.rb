class SessionsController < ApplicationController
  skip_before_filter :authenticate
  
  # GET /session
  def show
    first_url = session[:first_url]
    reset_session
    session[:first_url] = first_url if first_url
    respond_to do |format|
      format.html
      format.mobile { render :template => "sessions/show.html.erb" }      
    end
  end

  # POST /session
  def create
    authenticate_or_request_with_http_basic('Windows/AD') do |userid, password|
      
      if (Rails.env.development? && userid == TEST_USER)
        @user = session[:user] = userid
        redirect_to homes_path
        return @user
      end
      if (corporate_auth(userid, password))
        logger.debug 'Name: ' + LdapGet.name(userid)
        session[:user] = userid
        if session[:first_url] && Home.find_by_ublog_name(session[:user])
          redirect_to session[:first_url]
          session[:first_url] = nil
        else
          redirect_to homes_path
        end
      end
      @user = session[:user]
    end
  end

  private
  
  def corporate_auth(userid, password)
    if Rails.env.test?
      # allow a few users for test environment: test0, test1 ... test9
      if (userid =~ /test\d/)
          return password == ('secret' + userid[/\d/]) # secret0, secret1, ...
      end
    end
    # Replace with whatever auth is used in your Company
    LdapGet.auth(userid, password)
  end
end
