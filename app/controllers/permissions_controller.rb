class PermissionsController < ApplicationController
  def index
    @permissions = Permission.paginate :all, :page=>params[:page], :per_page=>session[:per_page], :order => 'module ASC, name ASC'
  end

  def new
    @modes = Permission.get_modes().collect{|x| [x,x]}
  end

  def edit
    @permission = Permission.find params[:id]
    @modes = Permission.get_modes().collect{|x| [x,x]}
  end

  def create
    @permission = Permission.new params[:permission]
    if @permission.save
      flash[:notice] = 'Permiso guardado con éxito'
      redirect_to :permissions
    else
      new
      render :new
    end
  end

  def update
    @permission = Permission.find params[:id]
    @permission.update_attributes(params[:permission])
    if @permission.save
      flash[:notice] = 'Permiso guardado con éxito'
      redirect_to :permissions
    else
      edit
      render :edit
    end
  end

  def destroy
    @permission = Permission.find params[:id]
    @permission.eliminate
    if @permission.errors.size.zero?
      flash[:notice] = "Permiso eliminado con éxito"
    else
      logger.error("Error eliminando permiso: #{@permission.errors.inspect}")
      flash[:type] = 'error'
      if not @permission.errors[:foreign_key].nil?
        flash[:notice] = 'El permiso no se puede eliminar porque tiene registros asociados'
      elsif not @permission.errors[:unknown].nil?
        flash[:notice] = @permission.errors[:unknown]
      else
        flash[:notice] = "El permiso no se ha podido eliminar"
      end
    end
    redirect_to :permissions
  end
end
