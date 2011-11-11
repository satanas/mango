class BatchesController < ApplicationController
  def index
    @batches = Batch.find :all
  end

  def new
    fill
    @batch = Batch.new :user_id => session[:user].id
  end

  def edit
    fill
    @batch = Batch.find params[:id], :include=>{:batch_hopper_lot=>{:hopper_lot=>[{:lot=>:ingredient}, :hopper]}}
  end

  def create
    @batch = Batch.new params[:batch]
    @saved = @batch.save
    if @saved
      flash[:notice] = 'Batch guardado con éxito'
      redirect_to :batches
    else
      fill
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
      fill
      render :edit
    end
  end

  def destroy
    @batch = Batch.find params[:id]
    @batch.eliminate
    if @batch.errors.size.zero?
      flash[:notice] = 'Batch eliminado con éxito'
    else
      logger.error("Error eliminando batch: #{@batch.errors.inspect}")
      flash[:type] = 'error'
      if not @batch.errors[:foreign_key].nil?
        flash[:notice] = 'El batch no se puede eliminar porque tiene registros asociados'
      elsif not @batch.errors[:unknown].nil?
        flash[:notice] = @batch.errors[:unknown]
      else
        flash[:notice] = "El batch no se ha podido eliminar"
      end
    end
    redirect_to :batches
  end

  private

  def fill
    @orders = Order.find :all, :conditions => ['completed = ?', false]
    @users = User.find :all, :order => 'name ASC'
    @schedules = Schedule.find :all, :order => 'name ASC'
    @hoppers = Hopper.actives_to_select
  end
end
