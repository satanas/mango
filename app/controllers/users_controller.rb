class UsersController < ApplicationController
  def index
    @users = User.paginate :all, :page=>params[:page], :per_page=>session[:per_page]
  end
  
  def edit
    @user = User.find params[:id]
  end
  
  def create
    @user = User.new params[:user]
    if @user.save
      flash[:notice] = 'Usuario guardado con éxito'
      redirect_to :users
    else
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
      render :edit
    end
  end
  
  def destroy
    @user = User.find params[:id]
    @user.eliminate
    if @user.errors.size.zero?
      flash[:notice] = "Usuario <strong>'#{@user.name}'</strong> eliminado con éxito"
    else
      flash[:notice] = "El usuario no se ha podido eliminar"
    end
    redirect_to :users
  end
def destroy
    @ingredient = Ingredient.find params[:id]
    @ingredient.eliminate
    if @ingredient.errors.size.zero?
      flash[:notice] = "Materia prima eliminada con éxito"
    else
      flash[:type] = 'error'
      if not @ingredient.errors[:foreign_key].nil?
        flash[:notice] = 'La materia prima no se puede eliminar porque tiene registros asociados'
      elsif not @ingredient.errors[:unknown].nil?
        flash[:notice] = @ingredient.errors[:unknown]
      else
        flash[:notice] = "La materia prima no se pudo eliminar"
      end
    end
    redirect_to :ingredients
  end
end
