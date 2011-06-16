class HoppersController < ApplicationController
  def index
    @hoppers = Hopper.find_active
  end

  def edit
    @ingredients = Ingredient.find :all, :order => 'name ASC'
    @hopper = Hopper.find params[:id]
  end

  def create
    @hopper = Hopper.new params[:hopper]
    if @hopper.save
      flash[:notice] = 'Hopper saved'
      redirect_to :hoppers
    else
      render :new
    end
  end

  def update
    puts "Hola, ¿cómo estás? #{params.inspect}"
    @hopper = Hopper.find params[:id]
    @hopper.deactivate_all_ingredients
    unless params[:hopper][:hopper_ingredient].blank?
      @hopper.hopper_ingredient << HopperIngredient.new(:ingredient_id => params[:hopper][:hopper_ingredient], :hopper_id => params[:id])
    end
    if @hopper.save
      flash[:notice] = 'Hopper saved'
      redirect_to :hoppers
    else
      render :edit
    end
  end

  def destroy
    @hopper = Hopper.find params[:id]
    @hopper.destroy()
    if @hopper.errors.size.zero?
      flash[:notice] = "Hopper <strong>'#{@hopper.number}'</strong> destroyed"
    else
      flash[:notice] = "Can't destroy hopper"
    end
    redirect_to :hoppers
  end
end
