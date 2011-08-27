class HomesController < ApplicationController
  before_filter :check_and_set_iframe, :except => [:index]
  before_filter :check_and_set_embed, :except => [:index]
  before_filter :check_and_set_json, :except => [:index]
  before_filter :set_visitor_home, :except => [:index, :create]
  before_filter :load_home_page, :only => [:show]

  respond_to :html, :xml, :mobile, :json, :js, :iframe, :embed, :except => [:index]
  # GET /homes
  # GET /homes.xml
  def index
    @homes = Home.find_all_by_ublog_name(@user)
    unless @homes.length > 0
      @home = Home.new(:ublog_name => @user, :owner => @user, :is_private => 0,
      :name => LdapGet.name(@user), :notify_calendar => 0,
      :is_group => 0)
      @home.name = "Test user" if @user =~ /test[0-9]/
    end
    respond_to do |format|
      if (@home)
        format.html { create_account_and_redirect }
        format.mobile { create_account_and_redirect }
        format.xml  { render :xml => @homes }
      else
        format.html { redirect_to @homes[0] }
        format.mobile { redirect_to @homes[0] }
        format.xml  { render :xml => @homes }
      end
    end
  end

  # GET /homes/1
  # GET /homes/1.xml
  def show
    # See if this is for mine, all or tags
    opts = {}
    # :all and :tag are mutually exclusive
    opts[:all] = session[:all]
    opts[:limit] = params[:limit] ? params[:limit].to_i : nil

    load_blogs(opts)
    @groups = @visitor_home.groups
    @rss_display = true

    # if blocked print a message
    if @blocked
      flash.now[:error] = "WARNING: Blocked Private Group."
      if @home.owner == @user
        flash.now[:notice] = "Please follow this account to unblock and use."
      else
        flash.now[:notice] = "You need to follow and then get approval. " +
        "Any member or owner can approve using the Subs link."
      end
    end

    # Output variation. Use alternative html
    # narrow_view and iframe are mutually exclusive
    show_form = session[:narrow_view] ? "narrow" : "html"
    blog_form = params[:iframe] ? "iframe" : "html"

    # Disable back button cache to support ajax updates
    if @page == 1
      headers['Cache-Control'] = "no-store, no-cache, must-revalidate"
    end

    respond_with(@blogs) do |format|
      format.html { render :template => "homes/show.#{show_form}.erb" }
      format.js { render :partial => "blog_table.#{blog_form}.erb", :locals => { :reply => true } }
      format.embed { render :partial => "blog_table.iframe.erb", :locals => { :reply => false } }
    end
  end

  # GET /homes/new
  # GET /homes/new.xml
  # Used to create group accounts
  def new
    @home = Home.new()
    # Set up defaults
    #    @home.ublog_name = @user
    @home.owner = @user
    #    @home.name = LdapGet.name(@user)
    # Privacy option for group
    @privacy = [["Public", 0], ["Private", 1]]

    respond_with(@home) do |format|
      format.mobile { render :template => "homes/new.html.erb" }
    end
  end

  # GET /homes/1/edit
  def edit
    @home = Home.find(params[:id])
  end

  # POST /homes
  # POST /homes.xml
  def create
    @home = Home.new(params[:home])
    @privacy = [["Public", 0], ["Private", 1]]

    # Validate account name. Either it should be owned by the person creating the account
    # or it should be a non-user account, like a group account, in which case
    # there will not be an LDAP entry for it.
    if (((@home.ublog_name == @user) && (@home.owner == @user)) ||
      !LdapGet.name(@home.ublog_name))
      ok_to_create = true
      @home.is_group = (@home.ublog_name == @user) ? 0 : 1
    else
      flash[:error] = 'Account name not available or does not match owner'
    end

    if ok_to_create && @home.save
      flash[:notice] = 'Account was successfully created.'
      respond_with(@home, :location => home_url(@home)) do |format|
        format.mobile { redirect_to @home }
      end
    else
      # Go back to index.
      respond_with(nil, :location => homes_url)
    end
  end

  # PUT /homes/1
  # PUT /homes/1.xml
  # Only used to update the photo
  def update
    @home = Home.find(params[:id])
    authorized = @admin || (@home.owner == @user)
    flash[:error] = "Not authorized" unless authorized
  
    if authorized and @home.update_attributes(params[:home])
      flash[:notice] = 'Photo was successfully uploaded.'
      respond_with(@home, :location => home_url(@home))
    else
      respond_with(@home, :location => edit_home_url(@home))
    end
  end

  # DELETE /homes/1

  # DELETE /homes/1.xml
  def destroy
    @home = Home.find(params[:id])
    # validate destroyer
    if @admin or (@home.owner == @user)
      # Remove the blogs and subscriptions in the account before destroying it
      @home.blogs.delete_all
      @home.friends.delete_all # subscriptions by this user (groups have none)
      @home.followers.delete_all # subscriptions to this user/group
      Blog.delete_all("to_id = @home.id") # replies to this account
      @home.destroy
    else
      flash[:error] = "Unauthorized delete"
    end

    respond_with(nil, :location => homes_url)
  end


  private

  # A valid log in by user will create his/her account in ublog
  def create_account_and_redirect
    if @home.save
      if session[:first_url]
        redirect_to session[:first_url]
        session[:first_url] = nil
      else
        redirect_to @home
      end
    else
      render :template => "homes/index.html.erb"
    end
  end



  # Collect blogs and forms for the user's page. Either the first page without

  # filters or a specific page with specific filters.
  # This is called from both the homes and displays controllers
  def load_blogs (opts={})
    # Distinguish between an owner and a visitor
    @owned_account = @home.ublog_name == @user
    @proxy = @home.proxy == @user ? @user : false
    @owned_account ||= (@home.ublog_name == "news") if @admin
    # Get friends
    @friend_homes = @home.friend_homes
    @friends = @home.friends
    @follower_homes = @home.follower_homes

    @blocked = false
    user_home_id = Home.find_by_ublog_name(@user).id
    # For private groups check for membership
    if @home.is_private == 1
      @is_private = true
      @blocked = true
      @home.followers.each do |friend|
        if (friend.home_id == user_home_id) &&
          (friend.is_approved == 1)
          @blocked = false
          break
        end
      end
    end
    # Tag subscriptions
    @tags = @home.tags

    @visitor_home = Home.find_by_ublog_name(@user)

    # collect my blogs for display and a count
    page_size = opts[:limit] ? opts[:limit] : PAGE_SIZE
    if @owned_account && opts[:all]
      @all = true
      @blogs = Blog.all_blogs(@home, page_size+1, offset = (@page -1)*page_size)
    else
      @mine = true
      @blogs = Blog.mine(@visitor_home.id, @owned_account, @fake_auth, @home,
        page_size+1, offset = (@page -1)*page_size)
    end
    # We asked for one more blog than page_size, check if we got that many
    # and pop a blog if needed
    @paginate = @blogs.length == page_size+1
    @blogs.pop if @paginate # remove the extra blog

    @blogs = [] if @blocked

    # Send some other vars for the show template
    if (@owned_account || @proxy)
      @new_blog = Blog.new() # allow adding a blog
      @new_blog.home_id = @home.id
      @new_blog.to_id = 0 # not a reponse. Set to default
      @new_blog.prev_in_thread = 0
      @already_following = true # we follow ourselves by default
    else
      @new_blog = Blog.new() # allow adding a response
      @new_blog.home_id = @visitor_home.id
      @new_blog.to_id = @home.id
      @new_blog.prev_in_thread = 0
    end
    if @home.ublog_name != @user # either visitor or admin on an owned account
      # Allow following this account
      # See if we are already following this account
      @already_following = @friend =
        Friend.find_by_home_id_and_friend_id(@visitor_home.id, @home.id)
      unless @already_following
        @friend = Friend.new() # allow following/stop following this account
        @friend.origin = @visitor_home
        @friend.friend_home = @home
        @friend.email_notify = 0
        @friend.is_approved = (@user == @home.owner) ? 1:0
      end
    end
  end

  def load_home_page
    # Load page 1 for specified home
    load_page(request.path_parameters[:id].to_i) # check for errors
  end

end

