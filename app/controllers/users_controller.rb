class UsersController < ApplicationController
  def index
    @users = User.paginate :all, :page=>params[:page], :per_page=>session[:per_page], :include=>[:role], :order => 'name ASC'
  end

  def new
    @roles = Role.get_all
  end

  def edit
    @user = User.find params[:id]
    @roles = Role.get_all
  end

  def create
    @user = User.new params[:user]
    if @user.save
      flash[:notice] = 'Usuario guardado con éxito'
      redirect_to :users
    else
      new
      render :new
    end
  end

  def update
    @user = User.find params[:id]
    @user.update_attributes(params[:user])
    if @user.save
      flash[:notice] = 'Usuario guardado con éxito'
      redirect_to :users
    else
      edit
      render :edit
    end
  end

  def destroy
    @user = User.find params[:id]
    @user.eliminate
    if @user.errors.size.zero?
      flash[:notice] = "Usuario eliminado con éxito"
    else
      logger.error("Error eliminando usuario: #{@user.errors.inspect}")
      flash[:type] = 'error'
      if not @user.errors[:foreign_key].nil?
        flash[:notice] = 'El usuario no se puede eliminar porque tiene registros asociados'
      elsif not @user.errors[:unknown].nil?
        flash[:notice] = @user.errors[:unknown]
      else
        flash[:notice] = "El usuario no se ha podido eliminar"
      end
    end
    redirect_to :users
  end
end
