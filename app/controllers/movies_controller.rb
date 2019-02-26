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
    @movies = Movie.all
      if params["sort_by"] == "title"
        @movies= Movie.all.order(title: :asc)#orders all movies by title by ascending order if think specifies sort by title
        @title_header = "hilite"#uses background color to mark currently used sort
      elsif params["sort_by"] == "release_date"
        @movies= Movie.all.order(release_date: :asc)#orders all movies by release date if think specifies sort by release date
        @release_date = "hilite"#uses background color to mark currently used sort
      elsif params["ratings"]#check if ratings are not nil
            @movies = Movie.where("rating" => params["ratings"].keys)#if no sort link is clicked on default display but apply filter
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
