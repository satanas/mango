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
  
  def search
    code = params['ingredient']['code']
    name = params['ingredient']['name']
    conditions, value = "code LIKE ?", code + "%" unless code.blank?
    conditions, value = "name LIKE ?", name + "%" unless name.blank?
    @ingredients = Ingredient.find :all, :conditions => [conditions, value]
    puts @ingredients.inspect
    respond_to do |format|
      format.js { render :layout=>false } #{render :search, :layout => false} - render :content_type => 'text/javascript'
    end
  end
end
