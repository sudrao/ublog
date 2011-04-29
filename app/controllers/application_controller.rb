# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  require 'auth_module'
  helper :all # include all helpers, all the time
  helper_method :asset_type_path, :my_base_url
  cache_sweeper :show_sweeper, :only => [:create, :update, :destroy]
  cache_sweeper :time_sweeper, :only => [:create]
  has_mobile_fu
  PAGE_SIZE = 25
  TEST_USER = '#{TESTUSER}'
    
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
#  protect_from_forgery  # :secret => '77a707a08b86cd4d5c0a001065e5d29c'
# No forgery protection to speed up caching. This should be OK for 
# a behind-the-firewall corporate application.
    
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password
  
  # Get the http://ublog.#{DOMAIN}.com part of the url
  # http or https assumed.
  def my_base_url
    request.protocol + request.host + 
      (request.port == 80 ? "" : ":" + request.port.to_s)
  end
  
  # Generate proper url for an image or thumbnail
  # {:only_path => false} should be sent in for absolute url
  def asset_type_path(asset, thumb=nil, opts = {})
    type = Mime::Type.lookup(asset.content_type) if asset
    thumb_url = thumb ? '/thumbs/1' : ''
    prefix = ""
    # Generate absolute url prefix if asked for
    prefix = my_base_url if (opts[:only_path] == false)
    if asset
      case type
      when Mime::JPG   
        url = thumb_url + '/assets/' + asset.id.to_s + '.jpg'
      when Mime::GIF
        url = thumb_url + '/assets/' + asset.id.to_s + '.gif'
      when Mime::PNG
        url = thumb_url + '/assets/' + asset.id.to_s + '.png'
      else
        # This is for an unknown type. Browser will show a broken image.
        url = thumb_url + '/assets/' + asset.id.to_s + '.jnk'
      end
    else
      thumb_str = thumb ? '_thumb' : ''
      url = "/images/ublog_default#{thumb_str}.png"
    end
    prefix + url
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
      respond_to do |format|
        format.html { redirect_to homes_url }
        format.xml { render :xml => Home.new.errors, :status => :unprocessable_entity }
      end
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

  def render(opts = {}, &block)
    if opts[:to_yaml] then
      headers["Content-Type"] = "text/plain;"
      render :text => Hash.from_xml(render_to_string(:template => opts[:to_yaml], :layout => false)).to_yaml, :layout => false
    elsif opts[:to_json] then
      headers["Content-Type"] = "text/javascript;"
      render :json => Hash.from_xml(render_to_string(:template => opts[:to_json], :layout => false)).to_json, :layout => false
    else
      super opts, &block
    end
  end
end
