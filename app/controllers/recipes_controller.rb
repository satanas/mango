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
end
