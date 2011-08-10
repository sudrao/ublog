class TagsubsController < ApplicationController
  before_filter :set_visitor_home
  before_filter :verify_owner, :only => [ :destroy ]
  

  # GET /tagsubs/new
  # GET /tagsubs/new.xml
  def new
    @tagsub = Tagsub.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @tagsub }
    end
  end

  # POST /tagsubs
  # POST /tagsubs.xml
  def create
    @tagsub = Tagsub.new(params[:tagsub])
    @tag = @tagsub.tag
    @home = @tagsub.home

    respond_to do |format|
      if @tagsub.save
        flash[:notice] = 'Tag was successfully subscribed.'
        format.html { redirect_to tag_url(@tag) }
        format.mobile { redirect_to tag_url(@tag) }
        format.xml  { render :xml => @tagsub, :status => :created, :location => @tagsub }
      else
        format.html { redirect_to @home }
        format.mobile { redirect_tp @home }
        format.xml  { render :xml => @tagsub.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tagsubs/1
  # PUT /tagsubs/1.xml
  def update
    @tagsub = Tagsub.find(params[:id])
    # Reset notified stamp in the account
    @home = @tagsub.home
    @home.update_attribute(:last_notified, Time.now.utc)
    
    respond_to do |format|
      if @tagsub.update_attributes(params[:tagsub])
#        flash[:notice] = 'Tagsub was successfully updated.'
        format.html { redirect_to(home_follow_path(@tagsub.home)) }
        format.mobile { redirect_to(home_follow_path(@tagsub.home)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.mobile { redirect_to home_follow_path(@tagsub.home) }
        format.xml  { render :xml => @tagsub.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tagsubs/1
  # DELETE /tagsubs/1.xml
  def destroy
    @tag = @tagsub.tag
    @home = @tagsub.home
    @tagsub.destroy
    
    respond_to do |format|
      format.html { redirect_to tag_url(@tag) }
      format.mobile { redirect_to tag_url(@tag) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def verify_owner
    @tagsub = Tagsub.find(params[:id])
    unless ((@visitor_home.id == @tagsub.home_id) and !@fake_auth) || @admin
      render :text => "ERROR: You are not authorized.", :status => 403
    end
  end

# GET /tagsubs
# GET /tagsubs.xml
def index
  @tagsubs = Tagsub.find(:all)

  respond_to do |format|
    format.html # index.html.erb
    format.xml  { render :xml => @tagsubs }
  end
end

# GET /tagsubs/1
# GET /tagsubs/1.xml
def show
  @tagsub = Tagsub.find(params[:id])

  respond_to do |format|
    format.html # show.html.erb
    format.xml  { render :xml => @tagsub }
  end
end

# GET /tagsubs/1/edit
def edit
  @tagsub = Tagsub.find(params[:id])
end

end
