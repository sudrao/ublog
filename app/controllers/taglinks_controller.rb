class TaglinksController < ApplicationController
  # GET /taglinks
  # GET /taglinks.xml
  def index
    @taglinks = Taglink.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @taglinks }
    end
  end

  # GET /taglinks/1
  # GET /taglinks/1.xml
  def show
    @taglink = Taglink.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @taglink }
    end
  end

  # GET /taglinks/new
  # GET /taglinks/new.xml
  def new
    @taglink = Taglink.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @taglink }
    end
  end

  # GET /taglinks/1/edit
  def edit
    @taglink = Taglink.find(params[:id])
  end

  # POST /taglinks
  # POST /taglinks.xml
  def create
    @taglink = Taglink.new(params[:taglink])

    respond_to do |format|
      if @taglink.save
        flash[:notice] = 'Taglink was successfully created.'
        format.html { redirect_to(@taglink) }
        format.xml  { render :xml => @taglink, :status => :created, :location => @taglink }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @taglink.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /taglinks/1
  # PUT /taglinks/1.xml
  def update
    @taglink = Taglink.find(params[:id])

    respond_to do |format|
      if @taglink.update_attributes(params[:taglink])
        flash[:notice] = 'Taglink was successfully updated.'
        format.html { redirect_to(@taglink) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @taglink.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /taglinks/1
  # DELETE /taglinks/1.xml
  def destroy
    @taglink = Taglink.find(params[:id])
    @taglink.destroy

    respond_to do |format|
      format.html { redirect_to(taglinks_url) }
      format.xml  { head :ok }
    end
  end
end
