class ScrapeRecipeOptionsService
  def initialize
    @url = "https://www.allrecipes.com/search?q="
  end

  def recipe_search(key_word)
    recipes = {}
    doc = Nokogiri::HTML(URI.open("#{@url}#{key_word}").read, nil, "utf-8")
    doc.search(".mntl-card-list-items").each do |element|
      if element.attributes["href"].value.include?("/recipe/") && recipes.length < 10
        recipes[element.search(".card__title-text").text.gsub(/\n/, "")] = element.attributes["href"].value
      end
    end
    recipes
  end
end
