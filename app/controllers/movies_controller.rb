class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings]
      session[:ratings] = params[:ratings]
      @ratings_to_show = params[:ratings]&.keys
    elsif session[:ratings]
      @ratings_to_show = session[:ratings].keys
    else
      @ratings_to_show = @all_ratings
    end
    @checked_ratings = @ratings_to_show
    # sorting
    order = params[:order] || 'title'
    direction = params[:direction] || 'asc'
    @current_order = order
    @current_dir = direction

    @movies = Movie.where(rating: @ratings_to_show).order("#{@current_order} #{@current_dir}")
  end  

  def get_ratings
    if params[:ratings]
      checked_ratings = params[:ratings].keys
      @movies = Movie.with_ratings(checked_ratings)
    else
      @movies == Movie.all
    end
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
