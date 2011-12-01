class SchedulesController < ApplicationController
  def index
    @schedules = Schedule.paginate :all, :page=>params[:page], :per_page=>session[:per_page]
  end

  def edit
    @schedule = Schedule.find params[:id]
  end

  def create
    @schedule = Schedule.new params[:schedule]
    if @schedule.save
      flash[:notice] = 'Turno guardado con éxito'
      redirect_to :schedules
    else
      render :new
    end
  end

  def update
    @schedule = Schedule.find params[:id]
    @schedule.update_attributes(params[:schedule])
    if @schedule.save
      flash[:notice] = 'Turno guardado con éxito'
      redirect_to :schedules
    else
      render :edit
    end
  end
  
  def destroy
    @schedule = Schedule.find params[:id]
    @schedule.eliminate
    if @schedule.errors.size.zero?
      flash[:notice] = "Turno eliminado con éxito"
    else
      logger.error("Error eliminando turno: #{@schedule.errors.inspect}")
      flash[:type] = 'error'
      if not @schedule.errors[:foreign_key].nil?
        flash[:notice] = 'El turno no se puede eliminar porque tiene registros asociados'
      elsif not @schedule.errors[:unknown].nil?
        flash[:notice] = @schedule.errors[:unknown]
      else
        flash[:notice] = "El turno no se ha podido eliminar"
      end
    end
    redirect_to :schedules
  end
end
