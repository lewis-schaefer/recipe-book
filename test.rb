require 'nokogiri'
require 'open-uri'

url = "https://www.allrecipes.com/recipe/13304/smoky-cod-and-parsnip-chowder/"

doc = Nokogiri::HTML(URI.open(url).read, nil, "utf-8")

title = doc.search("h1").text.strip
# description = doc.search("#article-subheading_2-0").text.strip
description = doc.search("p.article-subheading").text.strip
# rating = doc.search("#recipe-review-bar_1-0 #mntl-recipe-review-bar__rating_2-0").text.strip
rating = doc.search("div.mntl-recipe-review-bar__rating").text.strip
stats = doc.search(".mntl-recipe-details__content").text.strip
ingredients = doc.search("#mntl-structured-ingredients_1-0 .mntl-structured-ingredients__list-item").text.strip
# method = doc.search("#recipe__steps-content_1-0 li")

method = []
doc.search("#recipe__steps-content_1-0 li").each_with_index do |step, index|
  method << "#{index + 1}. #{step.text.gsub(/\n/, '')}\n\n"
end

nutrition = doc.search("#mntl-nutrition-facts-summary_1-0 tr").text.strip

img_link = []

# Search for all img tags
img_tags = doc.xpath("//img")

# Iterate over the img tags
img_tags.each do |img|
  # if img.attributes["src"]
  # Get the src attribute
  # if img.search(".primary-image__image")
  if img.attributes["class"].value.include?("primary-image__image")
    # if img.attributes["src"]
      img_link << img.attributes["src"].value
      break
    # end
  end
end
p img_link.join
