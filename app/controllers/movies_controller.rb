class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    movies = Movie.all
    @all_ratings = movies.distinct.pluck(:rating)
    @checked_ratings = @all_ratings
    ratings = params[:ratings]
    sort = params[:sort]
    session[:sort] = sort if not sort.nil?
    session[:ratings] = ratings.keys if not ratings.nil?
    movies = movies.with_ratings(session[:ratings]) if not session[:ratings].nil?
    movies = movies.order(session[:sort]) if not session[:sort].nil?
    @movies = movies
    @sort_col = session[:sort]
    @checked_ratings = session[:ratings] if not session[:ratings].nil?
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
