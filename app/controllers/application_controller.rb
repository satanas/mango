# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :check_authentication
  
  helper :flash
  helper :modal
  include ModalHelper::Modal
  
  def check_authentication
    puts 'check authentication'
    unless session[:user]
      #TODO Check usage
      session[:request] = action_name
      redirect_to :controller=>'session', :action=>'error'
    end
  end
  
end
