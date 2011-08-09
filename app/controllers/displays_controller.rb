# Notice that this controller class inherits from HomesController
class DisplaysController < HomesController
  
  # create is the primary action in this virtual resource
  # It is used to display a specific page with or without filters.
  # It gets page and other filter parameters in a form
  def create
    # Something changed, expire caches
    
    if (params[:all])
      session[:all] = (params[:all] == '1') ? true : false
      session[:tag] = nil # by selecting all or mine, tags are gone    
    end
    @home = Home.find(params[:home_id].to_i)
    page = params[:page].to_i
    if (page > 1)
      if load_page(params[:home_id].to_i, params[:page].to_i)
        opts = {}
        # :all and :tag are mutually exclusive
        opts[:all] = session[:all]
        load_blogs(opts)
        # Get photo
        @default_asset = Asset.find_by_filename("ublog_default.png")
        if (@home.asset)
          @asset = @home.asset
        else
          @asset = @default_asset
        end
      else
        return # error already shown
      end
      @groups = @visitor_home.groups
      output = session[:narrow_view] ? "narrow" : "html"

      respond_to do |format|
        format.html { render :template => "homes/show.#{output}.erb"}
        format.mobile { render :template => 'homes/show.mobile.erb' }
        format.xml  { render :xml => @blogs }
        format.iframe { render :template => "homes/show.iframe.erb"}
      end
    else
      respond_to do |format|
        format.html { redirect_to @home }
        format.mobile { redirect_to @home }
        format.xml  { render :xml => Home.new.errors, :status => :unprocessable_entity }
        format.iframe { redirect_to @home }
      end
    end
  end

  # If bookmarked, just go to homes index
  def show
    @home = Home.find(params[:home_id].to_i)
    respond_to do |format|
      format.html { redirect_to @home }
      format.mobile { redirect_to @home }
      format.xml { render :xml => Home.new.errors, :status => :unprocessable_entity }      
    end
  end
end
