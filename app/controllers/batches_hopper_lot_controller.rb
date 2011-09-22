class BatchesHopperLotController < ApplicationController

  def create
    if not params[:batch_hopper_lot][:amount].blank? or not params[:batch_hopper_lot][:hopper_lot_id].blank?
      b = BatchHopperLot.new params[:batch_hopper_lot]
      b.batch_id = params[:batch_id]
      if b.valid?
        b.save
        flash[:notice] = "Detalle agregado al batch"
      else
        flash[:notice] = "No se pudo guardar el detalle"
        flash[:type] = 'error'
      end
    else
      flash[:notice] = "Por favor coloque datos válidos"
      flash[:type] = 'error'
    end
    redirect_to edit_batche_path(params[:batch_id])
  end

  def destroy
    begin
      b = BatchHopperLot.find(params[:id])
      b.destroy
      flash[:notice] = "Detalle eliminado del batch"
    rescue Exception => ex
      flash[:notice] = "No se pudo borrar el detalle del batch"
      flash[:type] = 'error'
    end

    redirect_to edit_batche_path(params[:batch_id])
  end
end
