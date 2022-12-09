class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes do |t|
      t.string :title
      t.string :url
      t.string :description
      t.string :rating
      t.string :stats
      t.string :ingredients
      t.string :method
      t.string :nutrition
      t.timestamps null: false
    end
  end
end
