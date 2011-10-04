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

  def daily_production
    start_date = EasyModel.parse_date(params[:report], 'start')
    end_date = EasyModel.parse_date(params[:report], 'end')
    data = EasyModel.daily_production(start_date, end_date)
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      report = EasyReport::Report.new data, 'daily_production.yml'
      send_data report.render, :filename => "produccion_diaria.pdf", :type => "application/pdf"
    end
  end

  def order_details
    data = EasyModel.order_details(params[:report][:order])
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      report = EasyReport::Report.new data, 'order_details.yml'
      send_data report.render, :filename => "detalle_orden_produccion.pdf", :type => "application/pdf"
    end
  end
end
