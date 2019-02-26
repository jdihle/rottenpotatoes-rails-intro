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
    @all_ratings = Movie.possible_ratings
    currMovies = Movie.all
      if params[:ratings]#check if ratings are not nil also filter
        currMovies = currMovies.where("rating" => params[:ratings].keys)#if no sort link is clicked on default display but apply filter
        session[:saved_ratings] = params[:ratings] if params[:ratings]!=nil
      else
        params[:ratings] = session[:saved_ratings] if session[:saved_ratings]!=nil#if session settings are there load
        currMovies = currMovies.where("rating" => params[:ratings].keys)#if no sort link is clicked on default display but apply filter
        session[:saved_ratings] = params[:ratings] if params[:ratings]!=nil
      end
      
      #sort code
      if params[:sort_by] == "title"#the sorter
        currMovies = currMovies.order(title: :asc)#orders all movies by title by ascending order if think specifies sort by title
        @title_header = "hilite"#uses background color to mark currently used sort
        session[:saved_sort] = params[:sort_by] if params[:sort_by]!=nil
      elsif params[:sort_by] == "release_date"
        currMovies = currMovies.order(release_date: :asc)#orders all movies by release date if think specifies sort by release date
        @release_date = "hilite"#uses background color to mark currently used sort
        session[:saved_sort] = params[:sort_by] if params[:sort_by]!=nil
      else#if user has done nothing
          params[:sort_by] = session[:saved_sort] if session[:saved_sort]!=nil#if session settings are there load
          if params[:sort_by] == "title"#the sorter
            currMovies = currMovies.order(title: :asc)#orders all movies by title by ascending order if think specifies sort by title
            @title_header = "hilite"#uses background color to mark currently used sort
            session[:saved_sort] = params[:sort_by] if params[:sort_by]!=nil
          elsif params[:sort_by] == "release_date"
            currMovies = currMovies.order(release_date: :asc)#orders all movies by release date if think specifies sort by release date
            @release_date = "hilite"#uses background color to mark currently used sort
            session[:saved_sort] = params[:sort_by] if params[:sort_by]!=nil
          end
      end
    @movies = currMovies#return movie hash
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
