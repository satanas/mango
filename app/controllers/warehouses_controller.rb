class WarehousesController < ApplicationController
  def index
    @warehouses = Warehouse.paginate :all, :page=>params[:page], :per_page=>session[:per_page]
  end

  def new
    @warehouse_types = WarehouseType.all
    @ing_contents = Lot.find :all, :order => 'code ASC'
    @pdt_contents = ProductLot.find :all, :order => 'code ASC'
  end

  def edit
    @warehouse = Warehouse.get params[:id]
    @warehouse_types = WarehouseType.all
    @ing_contents = Lot.find :all, :order => 'code ASC'
    @pdt_contents = ProductLot.find :all, :order => 'code ASC'
  end

  def create
    @warehouse = Warehouse.new params[:warehouse]
    if @warehouse.save
      flash[:notice] = 'Almacén guardado con éxito'
      redirect_to :warehouses
    else
      new
      render :new
    end
  end

  def update
    @warehouse = Warehouse.get params[:id]
    @warehouse.update_attributes(params[:warehouse])
    if @warehouse.save
      flash[:notice] = 'Almacén guardado con éxito'
      redirect_to :warehouses
    else
      edit
      render :edit
    end
  end

  def destroy
    @warehouse = Warehouse.find params[:id]
    @warehouse.eliminate
    if @warehouse.errors.size.zero?
      flash[:notice] = "Almacén eliminado con éxito"
    else
      logger.error("Error eliminando almacén: #{@warehouse.errors.inspect}")
      flash[:type] = 'error'
      if not @warehouse.errors[:foreign_key].nil?
        flash[:notice] = 'El almacén no se puede eliminar porque tiene registros asociados'
      elsif not @warehouse.errors[:unknown].nil?
        flash[:notice] = @warehouse.errors[:unknown]
      else
        flash[:notice] = "El almacén no se ha podido eliminar"
      end
    end
    redirect_to :warehouses
  end

  def recalculate
    begin
      Warehouse.get_all().each do |w|
        w.recalculate
      end
      flash[:notice] = "Existencias recalculadas exitosamente"
    rescue Exception => e
      puts e.message
      flash[:type] = 'error'
      flash[:notice] = "Ha ocurrido un error recalculando las existencias"
    end
    redirect_to :warehouses
  end
end
