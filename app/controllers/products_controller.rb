class ProductsController < ApplicationController
  def index
    @products = Product.paginate :all, :page=>params[:page], :per_page=>session[:per_page]
  end
  
  def edit
    @product = Product.find params[:id]
  end
  
  def create
    @product = Product.new params[:product]
    if @product.save
      flash[:notice] = 'Producto terminado guardado con éxito'
      redirect_to :products
    else
      render :new
    end
  end
  
  def update
    @product = Product.find params[:id]
    @product.update_attributes(params[:product])
    if @product.save
      flash[:notice] = 'Producto terminado actualizado con éxito'
      redirect_to :products
    else
      render :edit
    end
  end
  
  def destroy
    @product = Product.find params[:id]
    @product.eliminate
    if @product.errors.size.zero?
      flash[:notice] = "Producto terminado eliminado con éxito"
    else
      logger.error("Error eliminando producto: #{@product.errors.inspect}")
      flash[:type] = 'error'
      if not @product.errors[:foreign_key].nil?
        flash[:notice] = 'El producto terminado no se puede eliminar porque tiene registros asociados'
      elsif not @product.errors[:unknown].nil?
        flash[:notice] = @product.errors[:unknown]
      else
        flash[:notice] = "El producto no se ha podido eliminar"
      end
    end
    redirect_to :products
  end
end
