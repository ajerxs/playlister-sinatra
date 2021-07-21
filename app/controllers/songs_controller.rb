require 'sinatra/base'
require 'rack-flash'

class SongsController < ApplicationController
    enable :sessions
    use Rack::Flash

    get '/songs' do
        @songs = Song.all
        erb :'songs/index'
    end

    get '/songs/new' do 
        @artists = Artist.all
        @genres = Genre.all
        erb :'songs/new'
    end

    post '/songs' do 
        @song = Song.create(name: params[:song][:name])

        if Artist.find_by(name: params[:song][:artist])
            @song.artist = Artist.find_by(name: params[:song][:artist])
        else
            @song.artist = Artist.create(name: params[:song][:artist])
        end

        genres = params[:song][:genres]
        genres.each do |genre|
            @song.genres << Genre.find(genre)
        end
        
        @song.save

        flash[:message] = "Successfully created song."
        redirect "/songs/#{@song.slug}"
    end


    get '/songs/:slug' do 
        @song = Song.find_by_slug(params[:slug])
        erb :'songs/show'
    end

    patch '/songs/:slug' do 
        @song = Song.find_by_slug(params[:slug])
        @song.name = params[:song][:name]

        if Artist.find_by(name: params[:song][:artist])
            if @song.artist.name != params[:song][:artist]
                @song.artist = Artist.find_by(name: params[:song][:artist])
            end
        else
            @song.artist = Artist.create(name: params[:song][:artist])
        end


        if @song.genres
            @song.genres.clear
        end
        genres = params[:song][:genres]
        genres.each do |genre|
            @song.genres << Genre.find(genre)
        end
        
        @song.save

        flash[:message] = "Successfully updated song."
        redirect "/songs/#{@song.slug}"
    end

    get '/songs/:slug/edit' do 
        @song = Song.find_by_slug(params[:slug])
        @genres = Genre.all
        erb :'songs/edit'
    end

end