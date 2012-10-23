class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # @movies = Movie.order(params[:sort])
    sort = params[:sort] || session[:sort]
=begin
    case sort
    when 'title'
      ordering,@sorted_by_title = {:order => :title}, 'hilite'
    when 'release_date'
      ordering,@sorted_by_date = {:order => :release_date}, 'hilite'
    end
=end
    # sort by title by default
    if sort == "release_date"
      ordering,@sorted_by_date = {:order => :release_date}, 'hilite'
    else
      ordering,@sorted_by_title = {:order => :title}, 'hilite'
    end

    @all_ratings = Movie.all_ratings
    @selected_ratings = params[:ratings] || session[:ratings] || {}
    
    if @selected_ratings == {}
      # @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
      @selected_ratings = Hash.new( @all_ratings.map {|rating| [rating, rating]} )
    end
    
    if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
      session[:sort] = sort
      session[:ratings] = @selected_ratings
      redirect_to :sort => sort, :ratings => @selected_ratings and return
    end
    @movies = Movie.find_all_by_rating(@selected_ratings.keys, ordering)
  end

=begin
  def sorted_alphabetical
    @movies = Movie.find(:all, :order => 'title')
  end
  def sorted_creation
    @movies = Movie.find(:all, :order => 'release_date')
  end
=end

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
