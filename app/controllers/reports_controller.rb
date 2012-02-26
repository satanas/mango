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

  def batch_details
    data = EasyModel.batch_details(params[:report][:order], params[:report][:batch])
    puts data.inspect
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      report = EasyReport::Report.new data, 'batch_details.yml'
      send_data report.render, :filename => "consumo_por_batch.pdf", :type => "application/pdf"
    end
  end

  def ingredient_variation
    start_date = EasyModel.parse_date(params[:report], 'start')
    end_date = EasyModel.parse_date(params[:report], 'end')
    data = EasyModel.ingredients_variation(start_date, end_date)
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      report = EasyReport::Report.new data, 'ingredient_variation.yml'
      send_data report.render, :filename => "variacion_materia_prima.pdf", :type => "application/pdf"
    end
  end

  def order_duration
    start_date = EasyModel.parse_date(params[:report], 'start')
    end_date = EasyModel.parse_date(params[:report], 'end')
    data = EasyModel.order_duration(start_date, end_date)
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      puts data.inspect
      report = EasyReport::Report.new data, 'order_duration.yml'
      send_data report.render, :filename => "duracion_de_orden_produccion.pdf", :type => "application/pdf"
    end
  end
end
