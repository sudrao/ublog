class GroupsController < ApplicationController
  before_filter :set_visitor_home
  
  # Show groups. Allow creating groups
  def index
    @home = Home.find_by_ublog_name(@user)
    @groups = Home.find_all_by_is_group(1, :order => "ublog_name") # when set to 1, the account is a group
    # Narrow and mobile views use the same form
    request.format = :mobile if session[:narrow_view]
    
    respond_to do |format|
      format.html # index.html.erb
      format.mobile
      format.xml  { render :xml => @groups }
    end
  end

end
