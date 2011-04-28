class SessionController < ApplicationController

  def index
    if session[:user]
      redirect_to :action=>'principal'
    end
  end
  
  def signin
  end
  
  def signout
  end
end
