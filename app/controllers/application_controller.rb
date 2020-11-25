class ApplicationController < ActionController::Base

  
  

  def index

    require 'rspotify'
    RSpotify.authenticate(ENV.fetch("Spotify_Client_ID"), ENV.fetch("Spotify_Client_Secret"))
    render({ :template => "index.html.erb"})
  end

end
