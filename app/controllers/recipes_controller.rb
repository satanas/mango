class RecipesController < ApplicationController
  def index
    @recipes = Recipe.find :all
  end
end
