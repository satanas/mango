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
      flash[:notice] = 'info'
      redirect_to :action => 'index'
    else
      puts @recipe.errors.inspect
      flash[:notice] = "Error importando receta"
      if not @recipe.errors[:upload_file].nil?
        flash[:notice] += ". #{@recipe.errors[:upload_file]}"
      elsif not @recipe.errors[:unknown].nil?
        flash[:notice] += ". #{@recipe.errors[:unknown]}"
      end
      logger.error(flash[:notice])
      redirect_to :action => 'import'
    end
  end

end
