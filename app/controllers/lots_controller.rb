class LotsController < ApplicationController
  def index
    @lots = Lot.paginate :all, :page=>params[:page], :per_page=>session[:per_page]
  end
  
  def new
    @ingredients = Ingredient.find :all, :order => 'name ASC'
  end
  
  def edit
    @lot = Lot.find params[:id]
    @ingredients = Ingredient.find :all, :order => 'name ASC'
  end
  
  def create
    @lot = Lot.new params[:lot]
    if @lot.save
      flash[:notice] = 'Lote guardado con éxito'
      redirect_to :lots
    else
      new
      render :new
    end
  end
  
  def update
    @lot = Lot.find params[:id]
    @lot.update_attributes(params[:lot])
    if @lot.save
      flash[:notice] = 'Lote guardado con éxito'
      redirect_to :lots
    else
      render :edit
    end
  end
  
  def destroy
    @lot = Lot.find params[:id]
    @lot.eliminate
    if @lot.errors.size.zero?
      flash[:notice] = "Lote eliminado con éxito"
    else
      flash[:type] = 'error'
      if not @lot.errors[:foreign_key].nil?
        flash[:notice] = 'El lote no se puede eliminar porque tiene registros asociados'
      elsif not @lot.errors[:unknown].nil?
        flash[:notice] = @lot.errors[:unknown]
      else
        flash[:notice] = "El lote no se ha podido eliminar"
      end
    end
    redirect_to :lots
  end
end
