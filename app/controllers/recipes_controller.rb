class RecipesController < ApplicationController
  def index
    @recipes = Recipe.find :all
  end
  
  def show
    @recipe = Recipe.find(params[:id], :include=>'ingredient_recipe')
  end
  
  def edit
    @recipe = Recipe.find(params[:id], :include=>'ingredient_recipe')
  end
end
