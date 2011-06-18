class HoppersController < ApplicationController
  def index
    @hoppers = Hopper.find_active
  end

  def new
    @ingredients = Ingredient.find :all, :order => 'name ASC'
  end

  def edit
    @ingredients = Ingredient.find :all, :order => 'name ASC'
    @hopper = Hopper.find params[:id]
  end

  def create
    @hopper = Hopper.new params[:hopper]
    if @hopper.save
      flash[:notice] = 'Tolva guardada con éxito'
      redirect_to :hoppers
    else
      render :new
    end
  end

  def update
    @hopper = Hopper.find params[:id]
    @hopper.deactivate_all_ingredients
    unless params[:hopper][:hopper_ingredient].blank?
      @hopper.hopper_ingredient << HopperIngredient.new(:ingredient_id => params[:hopper][:hopper_ingredient], :hopper_id => params[:id])
    end
    if @hopper.save
      flash[:notice] = 'Tolva actualizada con éxito'
      redirect_to :hoppers
    else
      render :edit
    end
  end

  def destroy
    @hopper = Hopper.find params[:id]
    @hopper.destroy()
    if @hopper.errors.size.zero?
      flash[:notice] = "Tolva eliminada con éxito"
    else
      flash[:notice] = "La tolva no se ha podido eliminar"
      flash[:type] = 'error'
    end
    redirect_to :hoppers
  end
end
