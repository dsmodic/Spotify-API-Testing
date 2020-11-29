class SpotifyController < ApplicationController
  before_action(:spotify_authentication)

  #SPOTIFY APP LOGIN
  def spotify_authentication
    require 'rspotify'
    RSpotify.authenticate(ENV.fetch("Spotify_Client_ID"), ENV.fetch("Spotify_Client_Secret"))
  end

  def search_form
    render({ :template => "/spotify/song_search_form.html.erb" })
  end

  def user_likes
    the_user_id = params.fetch("path_id")
    @the_user = User.all.where(id: the_user_id).first
    user_likes = @the_user.likes.order(created_at: "desc")
    
    if user_likes.count == 0
      @tracks = 0
    else
      liked_song_ids = user_likes.pluck(:song_id)
      @tracks = RSpotify::Track.find(liked_song_ids)
    end
    
    render({:template => "/likes/user_likes.html.erb"})

  end

  def user_feed
    follow_ids = @current_user.follows.pluck(:recipient_id)
    
    #Commented out to exclude user's own likes in their feed
    #follow_ids = follow_ids.push(@current_user.id)
    
    feed_likes = Like.all.where(user_id: follow_ids).order(created_at: "asc")
    
    if feed_likes.count == 0
      @tracks = 0
    else
      unique_feed_likes = feed_likes.uniq(&:song_id)
      desc_unique_feed_likes = Like.all.where(id: unique_feed_likes).order(created_at: "desc")
      feed_song_ids = desc_unique_feed_likes.pluck(:song_id)
      @tracks = RSpotify::Track.find(feed_song_ids)
    end

    render({template: "/likes/user_feed.html.erb"})
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