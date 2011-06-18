class RecipesController < ApplicationController
  def index
    @recipes = Recipe.find :all
  end
  
  def show
    @recipe = Recipe.find(params[:id], :include=>'ingredient_recipe', :order=>'id desc')
  end
  
  def edit
    @recipe = Recipe.find(params[:id], :include=>'ingredient_recipe', :order=>'ingredients_recipes.id desc')
  end

  def upload
    @recipe = Recipe.new
    if @recipe.import(params[:recipe])
      flash[:notice] = "Recipe imported successfully"
      redirect_to :action => 'index'
    else
      flash[:notice] = "Error importing recipe"
      redirect_to :action => 'import'
    end
  end

end
