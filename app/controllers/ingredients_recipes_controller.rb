class IngredientsRecipesController < ApplicationController
  def index
    @recipe = Recipe.find(params[:recipe_id], :include=>'ingredient_recipe', :order=>'ingredients_recipes.id desc')
  end

  def create
    @error = nil
    @recipe = Recipe.find(params[:recipe_id], :include=>'ingredient_recipe')
    ingredient = Ingredient.find_by_code(params[:ingredient_recipe][:code])

    ingredient_recipe = IngredientRecipe.new
    ingredient_recipe.ingredient = ingredient
    ingredient_recipe.recipe = @recipe
    ingredient_recipe.priority = params[:ingredient_recipe][:priority]
    ingredient_recipe.amount = params[:ingredient_recipe][:amount]
    ingredient_recipe.percentage = params[:ingredient_recipe][:percentage]

    if ingredient_recipe.valid?
      ingredient_recipe.save
      index
    else
      @error = "No se pudo guardar el ingrediente"
    end

    respond_to do |format|
      format.js { render :layout=>false }
    end
  end

  def destroy
    @error = nil
    begin
      ingredient_recipe = IngredientRecipe.find(params[:id])
      ingredient_recipe.destroy
      index()
    rescue Exception => ex
      puts ex.inspect
      @error = "No se pudo borrar el ingrediente de la receta"
    end
    respond_to do |format|
      format.js { render :layout=>false }
    end
  end
end
