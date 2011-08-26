module AuthModule

# Don't call this for fake_auth
def set_auth_vars
  @user = session[:user]
  @admin = (@user == 'janedoe')
end

def set_home
  if (!@home and params[:controller] == 'homes' and params[:id])
    @home = Home.find(params[:id]) 
  end
  @home
end

def show_for_home?
  request.get? and 
    params[:controller] == 'homes' and 
    params[:id]
end

def rss_access?
  request.format == Mime::RSS or request.format == Mime::ATOM
end

def json_access?
  request.format == Mime::JSON
end

def iframe_or_embed?
  format = request.path_parameters[:format]
  format == 'iframe' or format == 'embed' or params[:iframe]
end

def fake_auth_permitted?
  show_for_home? and set_home and (rss_access? or json_access? or 
    iframe_or_embed?) and 
    (@home.is_private != 1)
end

def set_fake_auth
  @user = @home.owner if (@home and @home.is_private != 1)
  @fake_auth = @user    
end

def do_basic_auth_inline
  authenticate_or_request_with_http_basic('Windows/AD') do |userid, password|
    if (LdapGet.auth(userid, password))
      session[:user] = userid
    end
  end    
end

def force_auth
  set_home
  if rss_access?
    do_basic_auth_inline
    set_auth_vars
  else
    session[:first_url] = request.url unless session[:first_url]
    redirect_to session_path, :method => 'post'
  end
end

# authenticate
# Case 1: logged in already - just set some vars and say OK
# Case 2: not logged in and resource != home, or action != show
#         in this case redirect to session for log in.
# Case 3: not logged in, GET homes/1 or 1.js or 1.xml
#         redirect to session for log in.
# Case 4: not logged in, GET homes/1.rss/atom/iframe/embed
#    in these cases, allow fake auth by setting @fake_auth
#    includes the case of .js with ?iframe=1
# In all cases, set @user, @visitor_home, @admin
def authenticate
#  logger.debug "Host name is: " + request.host
#  logger.debug "session user is:" + (session[:user].nil? ? "nil" : session[:user])
#  logger.debug request.headers["HTTP_AUTHORIZATION"].nil? ? "No auth present in request" : "Auth headers present"
  if session[:user]
    set_auth_vars
  elsif fake_auth_permitted?
    set_fake_auth
  else
    force_auth
  end
  @user
end
  

=begin
# Old code    
  def authenticate
  action = request.path_parameters['action']
  format_to_check = request.path_parameters[:format]
  format_to_check = 'iframe' if params[:iframe]
  case request.format
  when Mime::ATOM, Mime::RSS
    home = Home.find(params[:id])
    if home
      if (home.is_private && (home.is_private == 1))
        if session[:user]
          @user = session[:user]            
        else
            # Do http basic auth
          authenticate_or_request_with_http_basic('Windows/AD') do |userid, password|
            if (LdapGet.auth(userid, password))
              session[:user] = userid
            end
            @user = session[:user]
          end
        end
      else
        @user = home.owner
        @fake_auth = true
      end
    end 
    
  else
    case format_to_check
    when 'iframe', 'embed'
      logger.debug("Entering iframe/embed code. format_to_check is #{format_to_check.to_s}")
      session[:first_url] = request.url unless session[:first_url]
      unless session[:user]
        if action == 'show'
        # Allow read access
          home = Home.find(params[:id])
          if home and (home.is_private != 1)
            @user = home.owner
            @fake_auth = true
          end
        else
          redirect_to session_path
          return false
        end
      end
      @user = @user || session[:user]
      @visitor_home = Home.find_by_ublog_name(@user)

    else  
      unless session[:user]
        session[:first_url] = request.url unless session[:first_url]
        redirect_to session_path, :method => 'post'
        return false
      end
      @user = session[:user]
      @visitor_home = Home.find_by_ublog_name(@user)
      unless @visitor_home || action == 'create' || action == 'index'
        logger.debug("Could not find account for user #{@user} action was #{request.path_parameters['action']}")
        reset_session
        return false
      end
    end
  end  
  # Check if the user has admin privileges
  # Until we create a controller to add admins
  # let's just check specific names here.
  @admin = (@user == 'janedoe')
  @user
end
=end

end
