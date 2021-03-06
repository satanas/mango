class IngredientsRecipesController < ApplicationController
  def index
    @recipe = Recipe.find(params[:recipe_id], :include=>'ingredient_recipe')#, :order=>'ingredients_recipes.id desc')
    @ingredients = Ingredient.find :all
  end

  def create
    unless params[:ingredient_recipe][:code].blank?
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
        flash[:notice] = "Ingrediente agregado a la receta"
      else
        logger.error("No se pudo guardar el ingrediente: #{ingredient_recipe.errors.inspect}")
        flash[:notice] = "No se pudo guardar el ingrediente"
        flash[:type] = 'error'
      end
    else
      flash[:notice] = "Por favor seleccione un ingrediente válido"
      flash[:type] = 'error'
    end

    redirect_to edit_recipe_path(params[:recipe_id])
  end

  def destroy
    @ingredient_recipe = IngredientRecipe.find params[:id]
    @ingredient_recipe.eliminate
    if @ingredient_recipe.errors.size.zero?
      flash[:notice] = "Ingrediente eliminado de la receta con éxito"
    else
      logger.error("Error eliminando ingrediente de la receta: #{@ingredient_recipe.errors.inspect}")
      flash[:type] = 'error'
      flash[:notice] = "No se pudo borrar el ingrediente de la receta"
    end

    redirect_to edit_recipe_path(params[:recipe_id])
  end
end
