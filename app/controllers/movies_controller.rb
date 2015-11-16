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
  @all_ratings = Movie.all_ratings
  (params[:ratings].present?) ? @check_box=params[:ratings].keys :  @check_box = @all_ratings
  @movies_pre = Movie.all.where(:rating => @check_box)
    order = params[:sort]
    if order == "movie"
       @movies = @movies_pre.order(:title)
       @movie_toggle="hilite"
     elsif
       order =="release"
       @movies =@movies_pre.order(:release_date)
       @release_toggle="hilite"
     else
      @movies = @movies_pre
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

end
