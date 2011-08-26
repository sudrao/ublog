class FollowsController < ApplicationController
  before_filter :set_visitor_home
  
  def show
    @home = Home.find(params[:home_id].to_i)
    @group = @home.is_group == 1
    @private_group = @group && (@home.is_private == 1)
    # Check membership if private group
    if @private_group
      user_home_id = Home.find_by_ublog_name(@user).id
      @home.followers.each do |friend|
        if (friend.home_id == user_home_id) &&
             (friend.is_approved == 1)
          @member = true
          break
        end      
      end
    end
    @owned = @home.owner == @user
    @friends = []
    @home.friends.each do |friend|
      # Keep only valid entries
      @friends << friend if friend && friend.friend_home      
    end
    @friends.sort! do |f1, f2|
      f1.friend_home.ublog_name <=> f2.friend_home.ublog_name
    end
    @followers = []
    @home.followers.each do |f|
      @followers << f if f.origin
    end
    @followers.sort! do |f1, f2|
      f1.origin.ublog_name <=> f2.origin.ublog_name
    end
    # Tags subscribed
    @tagsubs = @home.tagsubs.sort do |ts1, ts2|
      ts1.tag.name <=> ts2.tag.name
    end
    # Allow email time setting
    @calendar = [["Disable all Email", 0], ["Every 20 minutes", 1], ["Hourly", 2],
    ["Twice a day", 3], ["Daily", 4]]

    respond_to do |format|
      format.html
      format.mobile { render :template => "follows/show.html.erb" }
      format.xml {render :xml => [@friends, @follower_homes, @tagsubs]}      
    end
  end
  
  # Used to change the notify_calendar
  def update
    @home = Home.find(params[:home_id].to_i)

    respond_to do |format|
      if @home.update_attributes(:notify_calendar => params[:home][:notify_calendar].to_i, 
            :last_notified => Time.now.utc, :email_list => params[:email_list])
        format.html { redirect_to :action => "show" }
        format.mobile { redirect_to :action => "show" }
        format.xml  { head :ok }
      else
        flash[:error] = @home.errors.full_messages.flatten
        format.html { redirect_to :action => "show" }
        format.mobile { redirect_to :action => "show" }
        format.xml  { render :xml => @home.errors, :status => :unprocessable_entity }
      end 
    end
  end
end
