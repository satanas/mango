class IngredientsController < ApplicationController
  def index
    @ingredients = Ingredient.find :all
  end
  
  def edit
    @ingredient = Ingredient.find params[:id]
  end
  
  def create
    @ingredient = Ingredient.new params[:ingredient]
    if @ingredient.save
      flash[:notice] = 'Ingrediente guardado con éxito'
      redirect_to :ingredients
    else
      render :new
    end
  end
  
  def update
    @ingredient = Ingredient.find params[:id]
    @ingredient.update_attributes(params[:ingredient])
    if @ingredient.save
      flash[:notice] = 'Ingrediente guardado con éxito'
      redirect_to :ingredients
    else
      render :edit
    end
  end
  
  def destroy
    @ingredient = Ingredient.find params[:id]
    @ingredient.destroy()
    if @ingredient.errors.size.zero?
      flash[:notice] = "Ingrediente <strong>'#{@ingredient.name}'</strong> eliminado con éxito"
    else
      flash[:notice] = "El ingrediente no se ha podido eliminar"
    end
    redirect_to :ingredients
  end
end
