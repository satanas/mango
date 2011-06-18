namespace :util do
  task :clean_ingredients => :environment do
    puts 'Borrando tabla ingredients_recipes...'
    IngredientRecipe.delete_all
    puts 'Borrando tabla recipes...'
    Recipe.delete_all
    puts 'Borrando tabla de ingredientes...'
    Ingredient.delete_all
    puts 'Purgados ingredientes'
  end
end
