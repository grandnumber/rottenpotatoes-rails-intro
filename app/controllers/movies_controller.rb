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

    if (params[:sort_by].blank? && params[:ratings].blank? && ! session[:sort_by].blank?)
      flash.keep
      redirect_to :sort_by => session[:sort_by], :ratings => session[:ratings]
    end

    if params[:sort_by]
      @sort_by = params[:sort_by].to_sym
    elsif session[:sort_by]
      @sort_by = session[:sort_by].to_sym
    else
      @sort_by = 'id'
    end

    @all_ratings = Movie.all_ratings
    if params[:ratings]
       @selected_ratings = params[:ratings].keys
     elsif session[:ratings]
       @selected_ratings = session[:ratings]
     else
         @selected_ratings = @all_ratings
    end
    session[:ratings] =  @selected_ratings
    session[:sort_by] = @sort_by
    params[:sort_by] == 'title' ? @movie_toggle="hilite" : @movie_toggle=""
    params[:sort_by] == 'release_date' ? @release_toggle="hilite" : @release_toggle=""
    @movies = Movie.where(:rating => @selected_ratings).order(@sort_by)
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
