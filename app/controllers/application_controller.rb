# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  before_filter :check_authentication, :check_permissions

  helper :flash
  helper :modal
  include ModalHelper::Modal

  # Pagination config
  PaginationHelper::DEFAULT_OPTIONS[:prev_title] = ''
  PaginationHelper::DEFAULT_OPTIONS[:next_title] = ''
  PaginationHelper::DEFAULT_OPTIONS[:first_title] = ''
  PaginationHelper::DEFAULT_OPTIONS[:last_title] = ''
  PaginationHelper::DEFAULT_OPTIONS[:prev_tooltip] = 'Pág. anterior'
  PaginationHelper::DEFAULT_OPTIONS[:next_tooltip] = 'Pág. siguiente'
  PaginationHelper::DEFAULT_OPTIONS[:first_tooltip] = 'Primera pág.'
  PaginationHelper::DEFAULT_OPTIONS[:last_tooltip] = 'Última pág.'

  def check_authentication
    unless session[:user]
      #TODO Check usage
      session[:request] = action_name
      redirect_to :controller=>'sessions', :action=>'index'
    end
  end

  def check_permissions
    return true if (controller_name == 'sessions')
    granted = session[:user].has_permission?(controller_name, action_name)
    return true if granted
    flash[:notice] = "No tiene permiso para acceder a ese recurso"
    flash[:type] = 'error'
    request.env["HTTP_REFERER"] ? (redirect_to :back) : (redirect_to :action=>'show', :controller=>'sessions')
    return false
  end

end
