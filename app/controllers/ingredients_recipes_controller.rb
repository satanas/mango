class IngredientsRecipesController < ApplicationController
  def create
    puts "create: #{params.inspect}"
    @recipe = Recipe.find(params[:recipe_id], :include=>'ingredient_recipe')
    ingredient = Ingredient.find_by_code(params[:ingredient_recipe][:code])
    puts ingredient.inspect
    ing_recipe = IngredientRecipe.new
    ing_recipe.ingredient = ingredient
    ing_recipe.recipe = @recipe
    ing_recipe.priority = params[:ingredient_recipe][:priority]
    ing_recipe.amount = params[:ingredient_recipe][:amount]
    ing_recipe.percentage = params[:ingredient_recipe][:percentage]
    ing_recipe.save
    puts ing_recipe.inspect
    
    @recipe = Recipe.find(params[:recipe_id], :include=>'ingredient_recipe', :order=>'ingredients_recipes.id desc')
    puts @recipe.inspect
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end
end
