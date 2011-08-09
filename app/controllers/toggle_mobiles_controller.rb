class ToggleMobilesController < ApplicationController
  # Fake singleton resource to change to and from mobile mode
  # It is under homes resource
  # Also used to create a combination of mobile and desktop views
  # called "narrow" mode. This mode has all javascript but removes
  # the multi-column CSS. Allows the browser window to be narrow.
    
  # POST /homes/1/toggle_mobiles
  def create
    @home = Home.find(params[:home_id])
    session[:mobile_view] = params[:mobile].to_i
    session[:narrow_view] = params[:narrow] == '1'
      
    redirect_to @home
  end

end
