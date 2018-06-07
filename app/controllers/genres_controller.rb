class GenresController < ApplicationController

  get '/genres' do
    @genres = Genre.all
    erb :"genres/index"
  end

  get '/genres/:slug' do
    @genre_name = params[:slug]
    @genre = Genre.find_by(name: @genre_name)
    erb :"/genres/show"
  end
end
