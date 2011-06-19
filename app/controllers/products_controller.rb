class ProductsController < ApplicationController
  def index
    @products = Product.find :all
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
    @product.destroy()
    if @product.errors.size.zero?
      flash[:notice] = "Producto terminado eliminado con éxito"
    else
      flash[:notice] = "El producto no se ha podido eliminar"
      flash[:type] = 'error'
    end
    redirect_to :products
  end
end
