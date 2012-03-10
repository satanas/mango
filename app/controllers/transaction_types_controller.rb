class TransactionTypesController < ApplicationController
  def index
    @transaction_types = TransactionType.paginate :all, :page=>params[:page], :per_page=>session[:per_page]
  end

  def edit
    @transaction_type = TransactionType.find params[:id]
  end

  def create
    @transaction_type = TransactionType.new params[:transaction_type]
    if @transaction_type.save
      flash[:notice] = 'Tipo de transacción guardado con éxito'
      redirect_to :transaction_types
    else
      render :new
    end
  end

  def update
    @transaction_type = TransactionType.find params[:id]
    @transaction_type.update_attributes(params[:transaction_type])
    if @transaction_type.save
      flash[:notice] = 'Tipo de transacción guardado con éxito'
      redirect_to :transaction_types
    else
      render :edit
    end
  end

  def destroy
    @transaction_type = TransactionType.find params[:id]
    @transaction_type.eliminate
    if @transaction_type.errors.size.zero?
      flash[:notice] = "Tipo de transacción eliminado con éxito"
    else
      logger.error("Error eliminando tipo de transacción: #{@transaction_type.errors.inspect}")
      flash[:type] = 'error'
      if not @transaction_type.errors[:foreign_key].nil?
        flash[:notice] = 'El tipo de transacción no se puede eliminar porque tiene registros asociados'
      elsif not @transaction_type.errors[:unknown].nil?
        flash[:notice] = @transaction_type.errors[:unknown]
      else
        flash[:notice] = "El tipo de transacción no se ha podido eliminar"
      end
    end
    redirect_to :transaction_types
  end
end
