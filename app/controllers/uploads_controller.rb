class UploadsController < ApplicationController
  respond_to :html, :xml
  
  # GET /uploads
  # GET /uploads.xml
  def index
  end

  # GET /uploads/1
  # GET /uploads/1.xml
  def show
    @upload = Upload.find(params[:id])

    respond_with(@upload)
  end

  # GET /uploads/new
  # GET /uploads/new.xml
  def new
    @upload = Upload.new

    respond_with(@upload)
  end

  # GET /uploads/1/edit
  def edit
    @upload = Upload.find(params[:id])
    
    respond_with(@upload)
  end

  # POST /uploads
  # POST /uploads.xml
  def create
    @upload = Upload.new(params[:upload])

    if @upload.save
      flash[:notice] = 'Attachment was successfully created.'
    else
      flash[:error] = "Could not upload your attachment."
    end
    respond_with(@upload)
  end

  # PUT /uploads/1
  # PUT /uploads/1.xml
  def update
    @upload = Upload.find(params[:id])

    if @upload.update_attributes(params[:upload])
      flash[:notice] = 'Attachment was successfully saved.'
    else
      flash[:error] = "Could not upload your attachment."
    end
    respond_with(@upload)
  end

  # DELETE /uploads/1
  # DELETE /uploads/1.xml
  def destroy
    @upload = Upload.find(params[:id])
    @upload.destroy
    respond_with(@upload)
  end
end
