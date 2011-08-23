class BatchesController < ApplicationController
  def index
    @batches = Batch.find :all
  end

  def new
    @orders = Order.find :all, :conditions => ['completed = ?', false]
    @recipes = Recipe.find :all, :order => 'name ASC'
    @clients = Client.find :all, :order => 'name ASC'
    @users = User.find :all, :order => 'name ASC'
    @schedules = Schedule.find :all, :order => 'name ASC'
    @hoppers = Hopper.find_active
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
end
