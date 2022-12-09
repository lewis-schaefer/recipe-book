require 'csv'

csv_file_path = File.join(__dir__, 'seed_recipes.csv')

# CSV.foreach(@csv_file_path) do |row|
CSV.foreach(csv_file_path, headers: :first_row, header_converters: :symbol) do |row|
  # recipe_details = { name: row[:title], description: row[:description], rating: row[:rating], info: {
  #   stats: row[:stats],
  #   ingredients: row[:ingredients],
  #   method: row[:method],
  #   nutrition: row[:nutrition]
  # } }

  Recipe.create(title: row[:title], url: row[:url], description: row[:description], rating: row[:rating],
                stats: row[:stats], ingredients: row[:ingredients], method: row[:method],
                nutrition: row[:nutrition], img_url: row[:img_url])

  # recipe = Recipe.new(recipe_details)
  # # add_recipe(recipe)
  # @recipes << recipe
end
