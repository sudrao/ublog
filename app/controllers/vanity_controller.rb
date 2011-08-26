class VanityController < ApplicationController
  # Catch all controller for /xxx
  # Search for xxx in Home and redirect to it
  
  def show
    home = Home.find_by_ublog_name(params[:vanity])
    if home
      redirect_to home_url(home)
    else
      render :file => Rails.root.join('public', '404.html'), :status => 404
    end
  end
end
