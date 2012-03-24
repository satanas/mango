class SessionsController < ApplicationController
  skip_before_filter :check_authentication
  layout 'login'
  
  def index
    redirect_to :action=>'show' if session[:user]
  end
  
  def show
    if session[:user]
      render :show, :layout => 'dashboard'
    else
      redirect_to :action=>'index'
    end
  end

  def create
    user = User.auth(params[:user][:login], params[:user][:password])
    if user
      session[:user] = user
      session[:per_page] = 12
      session[:company] = YAML::load(File.open("#{Rails.root.to_s}/config/global.yml"))['application']
      puts session.inspect
      redirect_to :action => 'show'
    else
      flash[:notice] = 'Credenciales inválidas'
      flash[:type] = 'error'
      redirect_to :action => 'index'
    end
  end

  def destroy
    session[:user] = nil
    session[:per_page] = nil
    session[:company] = nil
    redirect_to :action=>'index'
  end

  def not_implemented
    flash[:notice] = "Esa funcionalidad aún no está implementada"
    flash[:type] = 'warn'
    redirect_to :action => :show
  end

  private

  def select_layout
    session[:user].nil? ? 'login': 'dashboard'
  end
end
