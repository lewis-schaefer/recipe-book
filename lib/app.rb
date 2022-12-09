require 'sinatra'
require 'sinatra/reloader' if development?
require 'pry-byebug'
require 'better_errors'

configure :development do
  use BetterErrors::Middleware
  # BetterErrors.application_root = File.expand_path('..', __FILE__)
  BetterErrors.application_root = File.expand_path(__dir__, __FILE__)
end

require_relative '../config/application'

require_relative 'services/scrape_all_recipes_service'
require_relative 'services/scrape_recipe_options_service'

OPTIONS = ScrapeRecipeOptionsService.new
SCRAPE = ScrapeAllRecipesService.new

enable :sessions

set :root, File.expand_path('..', __dir__)
set :views, (proc { File.join(root, 'app/views') })
set :bind, '0.0.0.0'

after do
  ActiveRecord::Base.connection.close
end

get '/' do
  @recipes = Recipe.all.order(id: :desc)
  @search_results = []
  @search_results = session[:search_results] || []
  # session.clear
  erb :index
end

get '/recipes/:id' do
  id = params[:id]
  @recipe = Recipe.find(id)

  erb :recipes
end

post '/search' do
  session[:search_results] = OPTIONS.recipe_search(params[:search_term])
  redirect '/'
end

get '/scrape/:title' do
  title = params[:title]
  session[:search_results].each do |recipe|
    @url = recipe[1] if recipe[0] == title
  end
  recipe = SCRAPE.scrape_recipe(@url)
  # recipe[:description]

  Recipe.create(title: recipe[:title], url: recipe[:url], description: recipe[:description], rating: recipe[:rating],
                stats: recipe[:stats], ingredients: recipe[:ingredients], method: recipe[:method],
                nutrition: recipe[:nutrition])
  redirect '/'
end
