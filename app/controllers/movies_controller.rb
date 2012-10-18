class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
=begin
    if id.to_s =~ /\d/
        # @movie = Movie.find(:all, :order => 'title')
        @movie = Movie.find(id) # look up movie by unique ID
    else
        @movies = Movie.find(:all, :order => 'title')
    end
=end
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.all
    # @movies = Movie.find(:all, :order => 'title')
    # @movies = Movie.find(:all, :order => 'release_date')
    # @movies = Movie.order(params[:id])
    @movies = Movie.order(params[:sort])
  end

  def sorted_alphabetical
    @movies = Movie.find(:all, :order => 'title')
  end
  def sorted_creation
    @movies = Movie.find(:all, :order => 'release_date')
  end


  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
