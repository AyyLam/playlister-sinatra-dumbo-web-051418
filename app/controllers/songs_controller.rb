class SongsController < ApplicationController

  get '/songs' do
    @songs = Song.all
    erb :"songs/index"
  end

  get '/songs/new' do
    erb :"songs/new"
  end

  get '/songs/:slug' do
    @song = Song.find_by(name: params[:slug])
    erb :"songs/show"
  end

  post '/songs' do
    @artist = params[:song][:artist]
    @artist_obj = Artist.find_or_create_by(name: @artist)
    @artist_id = @artist_obj.id
    @song = Song.create(name: params[:song][:name], artist_id: @artist_id)
    @genre_ids = params[:genres]
    @genre_ids.each do |genre_id|
      SongGenre.create(song_id: @song.id, genre_id: genre_id)
    end
    redirect '/songs'
  end

  get '/songs/:slug/edit' do

    @song = Song.find_by(name: params[:slug])
    @song_name = @song.name
    @artist_name = @song.artist.name
    erb :"songs/edit"
  end

  patch '/songs/:slug' do
    @artist = params[:song][:artist]
    @artist_obj = Artist.find_or_create_by(name: @artist)
    @artist_id = @artist_obj.id
    @song = Song.find_by(name: params[:slug])
    @song.update(name: params[:song][:name], artist_id: @artist_id)
    @genre_ids = params[:genres]
    if !@genre_ids.empty?
      sgs = SongGenre.select {|sg| sg.song_id == @song.id} #all associations between song n genre before edits
      sg_ids = sgs.map {|sg| sg.genre_id} #grabs all id's of those associations before edits
      @genre_ids.each do |genre_id|
        if !sg_ids.include?(genre_id) #checks if those existing associations have this genre_id
          SongGenre.find_or_create_by(song_id: @song.id, genre_id: genre_id)
        end
      end
      sg_ids.each do |sg_id|
        if !@genre_ids.include?(sg_id)
          deleted_id = SongGenre.find_by(song_id: @song.id, genre_id: sg_id)
          SongGenre.delete(deleted_id)
        end
      end
      # raise error a song must have a genre
    end
    redirect "songs/:slug"
  end



end
