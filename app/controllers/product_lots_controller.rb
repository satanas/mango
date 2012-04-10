class ProductLotsController < ApplicationController
  def index
    @lots = ProductLot.paginate :all, :page=>params[:page], :per_page=>session[:per_page]
  end

  def new
    @products = Product.find :all, :order => 'code ASC'
  end

  def edit
    @lot = ProductLot.find params[:id]
    @products = Product.find :all, :order => 'code ASC'
  end

  def create
    @lot = ProductLot.new params[:lot]
    if @lot.save
      flash[:notice] = 'ProductLot. guardado con éxito'
      redirect_to :product_lots
    else
      new
      render :new
    end
  end

  def update
    @lot = ProductLot.find params[:id]
    @lot.update_attributes(params[:lot])
    if @lot.save
      flash[:notice] = 'Lote guardado con éxito'
      redirect_to :product_lots
    else
      render :edit
    end
  end

  def destroy
    @lot = ProductLot.find params[:id]
    @lot.eliminate
    if @lot.errors.size.zero?
      flash[:notice] = "Lote eliminado con éxito"
    else
      logger.error("Error eliminando lote: #{@lot.errors.inspect}")
      flash[:type] = 'error'
      if not @lot.errors[:foreign_key].nil?
        flash[:notice] = 'El lote no se puede eliminar porque tiene registros asociados'
      elsif not @lot.errors[:unknown].nil?
        flash[:notice] = @lot.errors[:unknown]
      else
        flash[:notice] = "El lote no se ha podido eliminar"
      end
    end
    redirect_to :product_lots
  end
end
