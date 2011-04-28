class SessionController < ApplicationController
  skip_before_filter :check_authentication
  
  def index
    if session[:user]
      redirect_to :action=>'principal'
    end
  end
  
  def create
    puts "Hoooola #{params.inspect}"
    user = User.auth(params[:user][:login], params[:user][:password])
    if user
      redirect_to :action => 'principal'
    else
      redirect_to :action => 'error'
    end
  end
  
  def destroy
  end
  
  def error
  end
end
