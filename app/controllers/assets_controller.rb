class AssetsController < HomesController
  caches_page :show
  
  # GET /assets/1
  # GET /assets/1.xml
  def show
    @asset = Asset.find(params[:id])
#    @home = Home.find(params[:home_id])
    show_thumbnail = params[:thumb_id] # see if /thumb/1 present
    respond_to do |format|
      format.html { render :action => 'show', :layout => false }
      format.jpg  { send_data(@asset.image_data(show_thumbnail),
                              :type  => 'image/jpeg',
                              :filename => @asset.create_temp_file,
                              :disposition => 'inline') }
      format.gif  { send_data(@asset.image_data(show_thumbnail),
                              :type  => 'image/gif',
                              :filename => @asset.create_temp_file,
                              :disposition => 'inline') }
      format.png  { send_data(@asset.image_data(show_thumbnail),
                              :type  => 'image/png',
                              :filename => @asset.create_temp_file,
                              :disposition => 'inline') }
    end
  rescue
    flash[:warning] = 'Could not find image.'
    redirect_to homes_url
  end

  # GET /homes/1/assets/new
  # GET /homes/1/assets/new.xml
  def new
    @asset = Asset.new
    @home = Home.find(params[:home_id])
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @asset }
    end
  end

  # POST /homes/1/assets
  # POST /homes/1/assets.xml
  def create
    @asset = Asset.new(params[:asset])
    @home = Home.find(params[:home_id])
    @asset.home = @home
    
    respond_to do |format|
      if @asset.save
        flash[:notice] = 'Asset was successfully created.'
        # Expire the caches for main and thumb asset and delete if old asset present
        if (@home.asset)
          expire_page(asset_type_path(@home.asset, false)) # main
          expire_page(asset_type_path(@home.asset, true)) # thumb
          # Deleting the main asset internally deletes thumbnails in attachment_fu
          Asset.delete(@home.asset_id)
        end
        @home.asset = @asset # link home to new photo
        @home.save
        format.html { redirect_to(@home) }
        format.xml  { render :xml => @asset, :status => :created, :location => @asset }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @asset.errors, :status => :unprocessable_entity }
      end
    end
  end

  private
  # Make public in development mode only
  
  # GET /assets
  # GET /assets.xml
  def index
    @assets = Asset.find(:all, :conditions => "thumbnail IS NULL")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @assets }
    end
  end
  # DELETE /assets/1
  # DELETE /assets/1.xml
  def destroy
    @asset = Asset.find(params[:id])
    @asset.destroy

    respond_to do |format|
      format.html { redirect_to(assets_url) }
      format.xml  { head :ok }
    end
  end
end
