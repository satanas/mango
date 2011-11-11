class OrdersController < ApplicationController
  def index
    @orders = Order.paginate :all, :page=>params[:page], :per_page=>session[:per_page]
  end

  def new
    @recipes = Recipe.find :all, :order => 'name ASC'
    @clients = Client.find :all, :order => 'name ASC'
    @users = User.find :all, :order => 'name ASC'
    @products = Product.find :all, :order => 'name ASC'
    @order = Order.new if @order.nil?
    unless session[:user].admin?
      @order.user_id = session[:user].id
    end
  end

  def edit
    @order = Order.find(params[:id])
    new
  end

  def create
    @order = Order.new params[:order]
    if @order.save
      flash[:notice] = 'Orden de producción guardada con éxito'
      redirect_to :orders
    else
      new
      render :new
    end
  end

  def update
    @order = Order.find params[:id]
    @order.update_attributes(params[:order])
    if @order.save
      flash[:notice] = 'Orden de producción actualizada con éxito'
      redirect_to :orders
    else
      new
      render :edit
    end
  end

  def destroy
    @order = Order.find params[:id]
    @order.eliminate
    if @order.errors.size.zero?
      flash[:notice] = 'Orden de producción eliminada con éxito'
    else
      logger.error("Error eliminando orden: #{@order.errors.inspect}")
      flash[:type] = 'error'
      if not @order.errors[:foreign_key].nil?
        flash[:notice] = 'La orden no se puede eliminar porque tiene registros asociados'
      elsif not @order.errors[:unknown].nil?
        flash[:notice] = @order.errors[:unknown]
      else
        flash[:notice] = "La orden no se ha podido eliminar"
      end
    end
    redirect_to :orders
  end
end
