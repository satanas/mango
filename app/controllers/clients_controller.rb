class ClientsController < ApplicationController
  def index
    @clients = Client.find :all
  end

  def edit
    @client = Client.find params[:id]
  end

  def create
    @client = Client.new params[:client]
    if @client.save
      flash[:notice] = 'Cliente guardado con éxito'
      redirect_to :clients
    else
      render :new
    end
  end

  def update
    @client = Client.find params[:id]
    @client.update_attributes(params[:user])
    if @client.save
      flash[:notice] = 'Cliente guardado con éxito'
      redirect_to :clients
    else
      render :edit
    end
  end
  
  def destroy
    @client = Client.find params[:id]
    @client.destroy()
    if @client.errors.size.zero?
      flash[:notice] = "Cliente <strong>'#{@client.name}'</strong> eliminado con éxito"
    else
      flash[:notice] = "El cliente no se ha podido eliminar"
    end
    redirect_to :clients
  end

end
