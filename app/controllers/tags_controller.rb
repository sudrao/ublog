class TagsController < ApplicationController
  skip_before_filter :authenticate, :only => [:index]
  before_filter :set_visitor_home, :except => [:index]
  before_filter :verify_owner, :only => [:destroy, :edit]
  caches_page :index
  
  respond_to :html, :js, :mobile, :xml
    
  # GET /tags
  # GET /tags.xml
  def index
    @tags = Tag.find(:all, :order => "name ASC")
    # Sort into buckets by last reference in blogs
    @tags24 = []
    @tags72 = []
    @tagsweek = []
    @tagsrest = []

    @tags.each do |tag|
      stamp = 2.weeks.ago
      tag.blogs.each do |blog|
        # Find latest blog stamp
        created = blog.created_at.localtime
        stamp = created if (stamp < created)
      end
      if stamp > 24.hours.ago
        @tags24 << tag
      elsif stamp > 72.hours.ago
        @tags72 << tag
      elsif stamp > 1.week.ago
        @tagsweek << tag
      else
        @tagsrest << tag
      end
    end
    if @tags24.length > 0
      js_response = @tags24.inject("Recent tags: ") { |s, t| s + '<a href="' + tag_url(t) + '">'+ t.name + '</a> ' } + 
          '<p> </p>'
    else
      js_response = ''
    end

    respond_with(@tags) do |format|
      format.js { render :text => js_response, :layout => false }
      format.mobile { render :template => "tags/index.html.erb" }
      format.xml  { render :xml => @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.xml
  def show
    @tag = Tag.find(params[:id].to_i)
    session[:tag] = @tag.id if @tag # used to go to next page
    @home = Home.find_by_ublog_name(@user)
    # Load page 1.
    load_page(@home.id)
    @blogs = Blog.tagged_blogs(@tag.id, PAGE_SIZE+1, offset = (@page -1)*PAGE_SIZE)
    @paginate = @blogs.length == PAGE_SIZE + 1
    @blogs.pop if @paginate # remove extra which was used to determine @paginate
    @visitor_home = Home.find_by_ublog_name(@user)
    @already_following = Tagsub.find_by_home_id_and_tag_id(@visitor_home.id, @tag.id)    
    @tagsub = Tagsub.find_or_initialize_by_home_id_and_tag_id(:home_id => @visitor_home.id, :tag_id => @tag.id,
              :email_notify => 0) # allow following
    # Send some other vars for the show template
    @new_blog = Blog.new() # allow adding a response
    @new_blog.home_id = @visitor_home.id
    @rss_display = true
    
    respond_with(@tag)
  end

  
  # GET /tags/new
  # GET /tags/new.xml
  def new
    @tag = Tag.new

    respond_with(@tag)
  end

  # POST /tags
  # POST /tags.xml
  # Not used:
  # See blogs_controller.rb where tags are created.
  def create
    @tagsub = Tagsub.new(:home_id => params[:home_id].to_i, 
                         :tag_id => params[:id].to_i)

    respond_with(@tagsub) do |format|
      if @tagsub.save
        flash[:notice] = 'Tag was successfully subscribed.'
        format.html { render :action => "index" }
        format.mobile { render :template => "tags/index.html.erb" }
        format.xml  { render :xml => @tagsub, :status => :created, :location => @tagsub }
      else
        format.html { render :action => "index" }
        format.mobile { render :template => "tags/index.html.erb" }
        format.xml  { render :xml => @tagsub.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /tags/1
  # PUT /tags/1.xml
  # This is actually used to create a Tagsub, not to edit a Tag
  def update
    @tagsub = Tagsub.new(:home_id => params[:home_id].to_i, 
                         :tag_id => params[:id].to_i)
    @tags = Tag.find(:all)
    @home = Home.find(params[:home_id].to_i)

    respond_with(@tagsub) do |format|
      if @tagsub.save
        flash[:notice] = 'Tag was successfully subscribed.'
        format.html { render :action => "index" }
        format.mobile { render :template => "tags/index.html.erb" }
        format.xml  { render :xml => @tagsub, :status => :created, :location => @tagsub }
      else
        format.html { render :action => "index" }
        format.mobile { render :template => "tags/index.html.erb" }
        format.xml  { render :xml => @tagsub.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /tags/1
  # DELETE /tags/1.xml
  # Used to unsubscribe. Remove from Tagsub
  def destroy
    @tagsub.destroy if @tagsub
    @tags = Tag.find(:all)
    @home = Home.find(params[:home_id].to_i)

    respond_with(nil) do |format|
      format.html { render :action => "index" }
      format.mobile { render :template => "tags/index.html.erb" }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def verify_owner
    @tagsub = Tagsub.find_by_home_id_and_tag_id(params[:home_id].to_i, params[:id].to_i)
    unless ((@visitor_home.id == @tagsub.home_id) and !@fake_auth) || @admin
      render :text => "ERROR: You are not authorized.", :status => 403
    end
  end

  # GET /tags/1/edit
  def edit
    @tag = Tag.find(params[:id])
  end

end
