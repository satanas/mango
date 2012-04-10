class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.paginate :all, :page=>params[:page], :per_page=>session[:per_page]
  end

  def new
    @transaction_types = TransactionType.all
    @warehouses = Warehouse.all
  end

  def edit
    @transaction = Transaction.find params[:id]
    @transaction_types = TransactionType.all
    @warehouses = Warehouse.all
  end

  def create
    ttype = TransactionType.find params[:transaction][:transaction_type_id]
    granted = session[:user].has_module_permission?('transactions', ttype.code)
    if granted
      @transaction = Transaction.new params[:transaction]
      @transaction.user = session[:user]
      @transaction.processed_in_stock = 1
      if @transaction.save
        flash[:notice] = 'Transacción guardada con éxito'
        redirect_to :transactions
      else
        new
        render :new
      end
    else
      new
      flash[:type] = 'error'
      flash[:notice] = 'No tiene permisos para realizar esa transacción'
      render :new
    end
  end

  def update
    @transaction = Transaction.find params[:id]
    @transaction.update_attributes(params[:transaction])
    if @transaction.save
      flash[:notice] = 'Transacción guardada con éxito'
      redirect_to :transactions
    else
      edit
      render :edit
    end
  end

  def destroy
    @transaction = Transaction.find params[:id]
    @transaction.eliminate
    if @transaction.errors.size.zero?
      flash[:notice] = "Transacción eliminada con éxito"
    else
      logger.error("Error eliminando transacción: #{@transaction.errors.inspect}")
      flash[:type] = 'error'
      if not @transaction.errors[:foreign_key].nil?
        flash[:notice] = 'La transacción no se puede eliminar porque tiene registros asociados'
      elsif not @transaction.errors[:unknown].nil?
        flash[:notice] = @transaction.errors[:unknown]
      else
        flash[:notice] = "La transacción no se ha podido eliminar"
      end
    end
    redirect_to :transactions
  end

  def reprocess
    begin
      Transaction.get_no_processed().each do |t|
        t.process
      end
      flash[:notice] = "Consumos de materia prima procesados exitosamente"
    rescue Exception => e
      puts e.message
      flash[:type] = 'error'
      flash[:notice] = "Ha ocurrido un error procesando los consumos"
    end
    redirect_to :transactions
  end
end
