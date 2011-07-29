class ReportsController < ApplicationController

  def recipes
    data = EasyModel.recipes
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      report = EasyReport::Report.new data, 'recipes.yml'
      send_data report.render, :filename => "recetas.pdf", :type => "application/pdf" #, :disposition => 'inline'
    end
  end
end
