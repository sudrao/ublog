class AllsController < ApplicationController
# No authentication. Only public messages shown and no way to post.
  
  # GET /all
  def show
    # Use a fake user
    @user = "feedback"
    @new_blog = Blog.new  # Not actually used
    @new_blog.home_id = 0
    @home = Home.find_by_ublog_name(@user);
    @nothread = true
    # Load page 1
    load_page(@home.id)
    @blogs = Blog.all_blogs(@home, PAGE_SIZE+1, offset = (@page -1)*PAGE_SIZE)
    if @blogs.length > PAGE_SIZE
      @blogs.pop
      @paginate = true
    end
    @rss_display = true
    
    # Output variation. Use alternative html
    output = session[:narrow_view] ? "narrow" : "html"
    
    respond_to do |format|
      format.html { render :template => "alls/show.#{output}.erb" }
      format.xml  { render :xml => @blogs }
      format.atom { render :template => "homes/show.atom.builder" }
      format.rss { render :template => "homes/show.rss.rxml" }
      format.mobile # show.mobile.erb
      format.json { render :json => @blogs}
      format.js { render :partial => "homes/blog_table.html.erb", :locals => { :reply => true } }
    end
   end
   
   # POST /all
   # Used to change the page or view mode
  def create
    @page = params[:page] ? params[:page].to_i : 1
    
    if (@page > 1)
      @user = "feedback"
      @new_blog = Blog.new  # Not actually used
      @new_blog.home_id = 0
      @home = Home.find_by_ublog_name(@user);
      @nothread = true
      if load_page(@home.id, @page)
        @blogs = Blog.all_blogs(@home, PAGE_SIZE+1, offset = (@page -1)*PAGE_SIZE)
        if @blogs.length > PAGE_SIZE
          @blogs.pop
          @paginate = true
        end
      else
        return # error already shown
      end
      output = session[:narrow_view] ? "narrow" : "html"

      respond_to do |format|
        format.html { render :template => "alls/show.#{output}.erb"}
        format.mobile { render :template => 'alls/show.mobile.erb' }
        format.xml  { render :xml => @blogs }
      end
    else
      session[:mobile_view] = params[:mobile].to_i if params[:mobile]
      session[:narrow_view] = params[:narrow] == '1'
      
      respond_to do |format|
        format.html { redirect_to all_path }
        format.mobile { redirect_to all_path }
        format.xml  { render :xml => Home.new.errors, :status => :unprocessable_entity }
      end
    end
  end

end
