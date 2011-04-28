class SessionController < ApplicationController
  skip_before_filter :check_authentication
  
  def index
    if session[:user]
      redirect_to :action=>'show'
    end
  end
  
  def create
    user = User.auth(params[:user][:login], params[:user][:password])
    if user
      session[:user] = user
      redirect_to :action => 'show'
    else
      redirect_to :action => 'error'
    end
  end
  
  def destroy
    session[:user] = nil
    redirect_to :action=>'index'
  end
  
  def error
  end
  
  def show
  end
end
