# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  require 'auth_module'
  helper :all # include all helpers, all the time
  helper_method :my_base_url
  cache_sweeper :show_sweeper, :only => [:create, :update, :destroy]
  cache_sweeper :time_sweeper, :only => [:create]
  has_mobile_fu
  before_filter :authenticate
  before_filter :check_and_set_js

  PAGE_SIZE = 25
  TEST_USER = "#{TESTUSER}"
    
  protect_from_forgery
    
  # Get the http://ublog.#{DOMAIN}.com part of the url
  # http or https assumed.
  def my_base_url
    request.protocol + request.host + 
      (request.port == 80 ? "" : ":" + request.port.to_s)
  end
  
  # Called from show_sweeper and displays_controller
  def expire_show_cache
    # Expire cache for everyone
    expire_fragment(%r{users/.*})
  end

  def load_page (id = 0, page = 1)
    error = 'Invalid URL' unless id > 0
    begin
      @home = Home.find(id) unless error
    rescue ActiveRecord::RecordNotFound
      error = 'Account not found'
    end unless error
    @page = page unless error
    error = 'Invalid page' unless error || (@page > 0)
    if error
      flash[:error] = error
      respond_with(nil, :location => homes_url)
      nil
    else
      # Provide links to feedback and news accounts
      @feedback = Home.find_by_ublog_name('feedback');
      @news = Home.find_by_ublog_name('news');
      @home
    end
  end
  
  private

  # Auth code moved to module
  include AuthModule
  
  # Mandatory before_filter except for GET homes, and POST homes
  # i.e. homes index and homes create.
  # Also not needed for log in.
  def set_visitor_home
      @visitor_home = Home.find_by_ublog_name(@user) if @user
  end  
  
  def check_and_set_iframe
#    logger.debug("path_parameters are: #{request.path_parameters.to_s}")
    request.format = :iframe if request.path_parameters['format'] == 'iframe'
  end
  
  def check_and_set_embed
    request.format = :embed if request.path_parameters['format'] == 'embed'
  end

  def check_and_set_json
    request.format = :json if request.path_parameters['format'] == 'json'
  end

 # TODO: This next filter should not be needed
  def check_and_set_js
    request.format = :js if request.xhr?
  end
end
