class SpotifyController < ApplicationController
  before_action(:spotify_authentication)

  def spotify_authentication
    require 'rspotify'
    RSpotify.authenticate(ENV.fetch("Spotify_Client_ID"), ENV.fetch("Spotify_Client_Secret"))
  end

  def search_form
    render({ :template => "/spotify/song_search_form.html.erb" })
  end

  def return_search_results
    
    song_name = params.fetch("query_song_name")
    if song_name == ""
      redirect_to("/search", { :alert => "You didn't enter a song" })
    else
      @tracks = RSpotify::Track.search(song_name, limit: 12, market: 'US')
      render({:template => "/spotify/song_search_results.html.erb"})
    end
  end

  def song_details
    @the_song_id = params.fetch("path_id")
    render({template: "/spotify/song_details"})
  end

end