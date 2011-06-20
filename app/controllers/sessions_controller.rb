class SessionsController < ApplicationController
  skip_before_filter :check_authentication
  layout 'login'
  
  def index
    redirect_to :action=>'show' if session[:user]
  end
  
  def show
    if session[:user]
      @popup = ModalHelper::Modal::Popup.new('Bienvenido', 'Bem-vindo. Voce vais falar portugues logo')
      render :show, :layout => 'dashboard'
    else
      redirect_to :action=>'index'
    end
  end

  def create
    user = User.auth(params[:user][:login], params[:user][:password])
    if user
      session[:user] = user
      session[:per_page] = 2
      redirect_to :action => 'show'
    else
      flash[:notice] = 'Credenciales inválidas'
      flash[:type] = 'error'
      redirect_to :action => 'index'
    end
  end

  def destroy
    session[:user] = nil
    redirect_to :action=>'index'
  end

  def not_implemented
    flash[:notice] = "Esa funcionalidad aún no está implementada"
    flash[:type] = 'warning'
    redirect_to :action => :show
  end

  private

  def select_layout
    session[:user].nil? ? 'login': 'dashboard'
  end
end
