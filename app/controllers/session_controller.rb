class SessionController < ApplicationController
  skip_before_filter :check_authentication
  
  def index
    if session[:user]
      redirect_to :action=>'principal'
    end
  end
  
  def create
    user = User.auth(params[:user][:login], params[:user][:password])
    if user
      session[:user] = user
      redirect_to :action => 'principal'
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
end
