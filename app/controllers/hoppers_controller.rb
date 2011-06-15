class HoppersController < ApplicationController
  def index
    @hoppers = Hopper.find :all, :order => 'number ASC'
  end

  def edit
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
    @hopper = Hopper.find params[:id]
    @hopper.update_attributes(params[:hopper])
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
