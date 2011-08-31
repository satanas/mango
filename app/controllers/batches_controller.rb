class BatchesController < ApplicationController
  def index
    @batches = Batch.find :all
  end

  def new
    @orders = Order.find :all, :conditions => ['completed = ?', false]
    @users = User.find :all, :order => 'name ASC'
    @schedules = Schedule.find :all, :order => 'name ASC'
    @hoppers = Hopper.actives_to_select
    @batch = Batch.new :user_id => session[:user].id
  end

  def edit
    @batch = Batch.find params[:id]
    @orders = Order.find :all, :conditions => ['completed = ?', false]
    @users = User.find :all, :order => 'name ASC'
    @schedules = Schedule.find :all, :order => 'name ASC'
    @hoppers = Hopper.actives_to_select
  end

  def create
    @batch = Batch.new params[:batch]
    if @batch.save
      flash[:notice] = 'Batch guardado con éxito'
      redirect_to :batches
    else
      new
      render :new
    end
  end

  def update
    @batch = Batch.find params[:id]
    @batch.update_attributes(params[:batch])
    if @batch.save
      flash[:notice] = 'Batch actualizado con éxito'
      redirect_to :batches
    else
      edit
      render :edit
    end
  end

  def destroy
    @batch = Batch.find params[:id]
    if @batch.eliminate
      flash[:notice] = 'Batch eliminado con éxito'
    else
      flash[:notice] = 'El batch no se pudo eliminar'
      flash[:type] = 'error'
    end
    redirect_to :batches
  end
end
