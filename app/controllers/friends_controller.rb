class FriendsController < ApplicationController
  before_filter :set_visitor_home
  before_filter :verify_owner, :only => [ :destroy ]  
  # POST /friends
  # POST /friends.xml
  def create
    @friend = Friend.new(params[:friend])
    @return_home = Home.find(@friend.friend_id)

    respond_to do |format|
      if @friend.save
        format.html { redirect_to home_url(@return_home) }
        format.mobile { redirect_to home_url(@return_home) }
        format.xml  { render :xml => @friend, :status => :created, :location => @friend }
      else
        format.html { render :action => "new" }
        format.mobile { render :template => "friends/new.html.erb" }
        format.xml  { render :xml => @friend.errors, :status => :unprocessable_entity }
      end
    end
  end

# DELETE /friends/1
# DELETE /friends/1.xml
def destroy
  @return_home = Home.find(@friend.friend_id)
  @friend.destroy

  respond_to do |format|
    format.html { redirect_to home_url(@return_home) }
    format.mobile { redirect_to home_url(@return_home) }
    format.xml  { head :ok }
  end
end

# PUT /friends/1
# PUT /friends/1.xml
# Either email_notify changed for friend OR
# is_approved changed for follower
# Since approver can be anyone we have no check on who is
# making this change.
def update
  @friend = Friend.find(params[:id])
  # Reset notified stamp in the account
  @home = @friend.origin
  @home.update_attribute(:last_notified, Time.now.utc)
  return_home = params[:friend][:email_notify] ? @home : @friend.friend_home
  
  respond_to do |format|
    if @friend.update_attributes(params[:friend])
#      flash[:notice] = 'Friend was successfully updated.'
      format.html { redirect_to(home_follow_path(return_home)) }
      format.mobile { redirect_to(home_follow_path(return_home)) }
      format.xml  { head :ok }
    else
      format.html { render :action => "edit" }
      format.mobile { redirect_to(home_follow_path(return_home)) }
      format.xml  { render :xml => @friend.errors, :status => :unprocessable_entity }
    end
  end
end

private
# GET /friends
# GET /friends.xml
def index
  @friends = Friend.find(:all)

  respond_to do |format|
    format.html # index.html.erb
    format.xml  { render :xml => @friends }
  end
end

# GET /friends/1
# GET /friends/1.xml
def show
  @friend = Friend.find(params[:id])

  respond_to do |format|
    format.html # show.html.erb
    format.xml  { render :xml => @friend }
  end
end

# GET /friends/new
# GET /friends/new.xml
def new
  @friend = Friend.new

  respond_to do |format|
    format.html # new.html.erb
    format.xml  { render :xml => @friend }
  end
end

# GET /friends/1/edit
def edit
  @friend = Friend.find(params[:id])
end

  def verify_owner
    @friend = Friend.find(params[:id])
    unless ((@visitor_home.id == @friend.home_id) and !@fake_auth) || @admin
      render :text => "ERROR: You are not authorized.", :status => 403
    end
  end

end
