class BlogsController < ApplicationController
  before_filter :authenticate
  before_filter :set_visitor_home
  before_filter :verify_owner, :only => [ :edit, :update, :destroy ]
  

  # GET /blogs/new
  # GET /blogs/new.xml
  def new
    @blog = Blog.new
    @blog.home_id = params[:home_id]
    @blog.to_id = params[:to_id]
    @target = @blog.to.ublog_name
    @return_id = params[:return_id]
    @return_format = params[:return_format]
    @blog.thread = params[:thread]
    @blog.prev_in_thread = params[:prev]
    @size = 138 - @target.length
    # Narrow, iframe, and mobile views use the same form
    request.format = :mobile if session[:narrow_view]
    request.format = :mobile if params[:return_format] == "iframe"
    
    respond_to do |format|
      format.html # new.html.erb
      format.mobile #new.mobile.erb
      format.xml  { render :xml => @blog }
    end
  end

  # POST /blogs
  # POST /blogs.xml
  def create
    @blog = Blog.new(params[:blog])
    @blog.proxy = params[:proxy] # if any
    # Record source of blog if mobile source
    if is_mobile_device?
      @blog.source = user_agent_device_name
      @blog.source ||= 'mobile'
    end
    @home = origin = @blog.origin
    # Check if this is an @reply. If it is, then record that in 'to' field
    other = @blog.content.split(' ', 2)[0] # extract the first word; blank separator
    if (other && (other[0] == ?@)) # ?@ is the ASCII for @
      if (@blog.to_id != 0) # user should not use @reply as it is assumed
        flash[:error] = 'You are visiting another account. No need for @reply here. It will be added automatically.'
        invalid_update = true
      else 
        other_home = Home.find_by_ublog_name(other[1..-1]) # [start..end] subtring. -1 means last
        flash[:error] = 'Invalid ublog name in @reply. Try another name. Nothing updated.' unless other_home
        invalid_update = true unless other_home
        @blog.to_id = other_home.id if other_home
      end
    else
      if (other && (@blog.to_id != 0)) # This blog is posted on another person's account page
        # insert the @reply 
        @blog.content = '@' + @blog.to.ublog_name + ' ' + @blog.content
        return_home = Home.find(params[:return_id]) if params[:return_id]
        @home = return_home || @blog.to # stay on the account being visited unless specified
      else 
        if (!other)
          invalid_update = true
# [Allow blank update to refresh screen] # flash[:error] = 'Type in something and then click Update'
        end
      end
    end
    
    # Make sure the person posting the blog is owner of the account
    invalid_update = true unless (origin.ublog_name == @user) or (origin.proxy == @user) or @admin
    
    unless invalid_update
      # See if private and mark
      if (to = @blog.to) && to.is_private && (to.is_private == 1)
        @blog.is_private = 1
      end
      # save blog and update tags
      invalid_update  = !@blog.save
      unless invalid_update
        @blog.taglist.each do |tagname|
          tag = Tag.find_or_create_by_name(tagname)
          if tag
            Taglink.create(:blog_id => @blog.id, :tag_id => tag.id)
          end
        end
        # Create attachment if any
        unless (params[:uploaded_data].blank?)
          upload = Upload.new(:uploaded_data => params[:uploaded_data])
          upload.blog = @blog
          begin
            if upload.save!
              logger.debug "Saved attachment #{upload.filename}"
            end
          rescue
            flash[:error] = upload.content_type + ":" + upload.errors.to_s
          end
        end
      end      
    end

    # Narrow and mobile views use the same form
    request.format = :mobile if session[:narrow_view]
    
    return_url = home_url(@home)
    return_url += "." + params[:return_format] if params[:return_format]
    
    respond_to do |format|
      if !invalid_update
        format.html { 
          logger.debug("The return home is #{@home.ublog_name}")
          redirect_to return_url unless params[:send_js]
          if (params[:send_js])
            responds_to_parent do
              render :update do |page|
                page.redirect_to return_url
              end
            end
          end
        }
        format.mobile { redirect_to return_url }
        format.xml  { render :xml => @blog, :status => :created, :location => @blog }
        format.js { render :partial => "done" } #{ render :text => "<h1>Sent!</h1><br /> <a  href=\"\"><button id=\"reply_ok\" >OK</button></a>" }
      else
        format.html { redirect_to return_url }
        format.mobile { redirect_to return_url }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
        format.js { render :text => "Sorry, there was an error" }
      end
    end
  end

  # PUT /blogs/1
  # PUT /blogs/1.xml
  def update
    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        flash[:notice] = 'Blog was successfully updated.'
        format.html { redirect_to(@blog) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @blog.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blogs/1
  # DELETE /blogs/1.xml
  def destroy
    return_url = home_url(@blog.home_id)
    Taglink.delete_all("blog_id = #{@blog.id}")
    @blog.destroy
    
    if (params[:return_id])
      return_url = home_url(params[:return_id])
      return_url += "." + params[:return_format] if params[:return_format]
    end   
    
    respond_to do |format|
      format.html { redirect_to return_url }
      format.mobile { redirect_to return_url }
      format.xml  { head :ok }
    end
  end
  
  def index
    render :text => "Not Found", :status => 404
  end
 
  def show
    render :text => "Not Found", :status => 404
  end

  def edit
    render :text => "Not Found", :status => 404
  end

  private
  
  def verify_owner
    @blog = Blog.find(params[:id])
    unless ((@visitor_home.id == @blog.home_id) and !@fake_auth) || @admin
      render :text => "ERROR: You are not authorized.", :status => 403
    end
  end
end
