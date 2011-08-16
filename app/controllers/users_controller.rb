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
end
