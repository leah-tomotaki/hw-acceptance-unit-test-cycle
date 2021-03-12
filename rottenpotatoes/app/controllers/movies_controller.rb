# class MoviesController < ApplicationController

#   def show
#     id = params[:id] # retrieve movie ID from URI route
#     @movie = Movie.find(id) # look up movie by unique ID
#     # will render app/views/movies/show.<extension> by default
#   end

#   def index
#     sort = params[:sort] || session[:sort]
#     case sort
#     when 'title'
#       ordering,@title_header = {:title => :asc}, 'bg-warning hilite'
#     when 'release_date'
#       ordering,@date_header = {:release_date => :asc}, 'bg-warning hilite'
#     end
#     @all_ratings = Movie.all_ratings
#     @selected_ratings = params[:ratings] || session[:ratings] || {}

#     if @selected_ratings == {}
#       @selected_ratings = Hash[@all_ratings.map {|rating| [rating, rating]}]
#     end

#     if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
#       session[:sort] = sort
#       session[:ratings] = @selected_ratings
#       redirect_to :sort => sort, :ratings => @selected_ratings and return
#     end
#     @movies = Movie.where(rating: @selected_ratings.keys).order(ordering)
#   end

#   def new
#     # default: render 'new' template
#   end

#   def create
#     @movie = Movie.create!(params[:movie])
#     flash[:notice] = "#{@movie.title} was successfully created."
#     redirect_to movies_path
#   end

#   def edit
#     @movie = Movie.find params[:id]
#   end

#   def update
#     @movie = Movie.find params[:id]
#     @movie.update_attributes!(params[:movie])
#     flash[:notice] = "#{@movie.title} was successfully updated."
#     redirect_to movie_path(@movie)
#   end

#   def destroy
#     @movie = Movie.find(params[:id])
#     @movie.destroy
#     flash[:notice] = "Movie '#{@movie.title}' deleted."
#     redirect_to movies_path
#   end
  
#   private
#     def movie_params
#       params.require(:movie).permit(:title, :rating, :description, :release_date)
#     end

# end
class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # session.clear()
    # user is NOT using special links
    if(params[:ratings] == nil && params[:sort] == nil) 
      # if session exists, page has already been visited --> use stored values
      @ratings_to_show = session[:ratings] == nil ? [] : session[:ratings]
      @sort = session[:sort] == nil ? "" : session[:sort]
      
    # page is refreshed from checkbox submit or sort 
    else 
      if(params[:ratings] == nil)
        # no boxes selected --> show all
        @ratings_to_show = [] 
      else
        @ratings_to_show =  params[:ratings].keys
      end
      # save updates in session 
      session[:ratings] = @ratings_to_show  
      
      if(params[:sort] != nil)
        @sort = params[:sort]
        session[:sort] = params[:sort]
      else
        @sort = "" #Default value, no sort
      end
    end
    
    # Update column header colors
    @release_date_class = ""
    @title_class = ""
    if(@sort == "title")
      @title_class = "hilite bg-warning"
    elsif(@sort == "release_date")
      @release_date_class = "hilite bg-warning"
    end
    
    @movies = Movie.with_ratings(@ratings_to_show).order(@sort)
    @all_ratings = Movie.all_ratings()
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
    params.require(:movie).permit(:title, :rating, :description, :release_date, :director)
  end
end
