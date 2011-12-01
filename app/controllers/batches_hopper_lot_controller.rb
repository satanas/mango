class BatchesHopperLotController < ApplicationController

  def create
    if not params[:batch_hopper_lot][:amount].blank? or not params[:batch_hopper_lot][:hopper_lot_id].blank?
      hopper_lot = HopperLot.find(params[:batch_hopper_lot][:hopper_lot_id])
      batch = Batch.find(params[:batch_id])

      b = BatchHopperLot.new params[:batch_hopper_lot]
      b.batch = batch
      b.hopper_lot = hopper_lot
      if b.valid?
        b.save
        flash[:notice] = "Detalle agregado al batch"
      else
        puts b.errors.inspect
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
    @batch_hopper_lot = BatchHopperLot.find params[:id]
    @batch_hopper_lot.eliminate
    if @batch_hopper_lot.errors.size.zero?
      flash[:notice] = "Detalle de batch eliminado con éxito"
    else
      logger.error("Error eliminando detalle de batch: #{@batch_hopper_lot.errors.inspect}")
      flash[:type] = 'error'
      flash[:notice] = "No se pudo borrar el detalle de batch"
    end

    redirect_to edit_batche_path(params[:batch_id])
  end
end
