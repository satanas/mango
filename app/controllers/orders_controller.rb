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
    if @order.destroy
      flash[:notice] = 'Orden de producción eliminada con éxito'
    else
      flash[:notice] = 'La orden de producción no se pudo eliminar'
      flash[:type] = 'error'
    end
    redirect_to :orders
  end
end
