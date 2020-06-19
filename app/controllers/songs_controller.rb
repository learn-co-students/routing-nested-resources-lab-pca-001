class SongsController < ApplicationController
  def index
    if params[:artist_id] #if url includes an artist Id
      @artist = Artist.find_by(id: params[:artist_id]) # then artist = artist id
      if @artist.nil? # if there is no artist for that id
        redirect_to artists_path, alert: "Artist not found" # redirect back to artist index
      else
        @songs = @artist.songs # if there is an artist, list all songs for that artist
      end
    else
      @songs = Song.all # if there is no artist id in url then just list all songs
    end
  end

  def show
    if params[:artist_id] # if url includes an artist Id
      @artist = Artist.find_by(id: params[:artist_id]) # then artist = artist id
      @song = @artist.songs.find_by(id: params[:id]) # song = the song id in url
      if @song.nil? # if there is no song for that id
        redirect_to artist_songs_path(@artist), alert: "Song not found" # go back to list of artist songs
      end
    else
      @song = Song.find(params[:id]) # if no artist id just show info for the song with id in url
    end
  end

  def new
    @song = Song.new
  end

  def create
    @song = Song.new(song_params)

    if @song.save
      redirect_to @song
    else
      render :new
    end
  end

  def edit
    @song = Song.find(params[:id])
  end

  def update
    @song = Song.find(params[:id])

    @song.update(song_params)

    if @song.save
      redirect_to @song
    else
      render :edit
    end
  end

  def destroy
    @song = Song.find(params[:id])
    @song.destroy
    flash[:notice] = "Song deleted."
    redirect_to songs_path
  end

  private

  def song_params
    params.require(:song).permit(:title, :artist_name)
  end
end

