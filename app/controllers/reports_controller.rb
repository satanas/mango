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

  def order_duration
    start_date = EasyModel.parse_date(params[:report], 'start')
    end_date = EasyModel.parse_date(params[:report], 'end')
    data = EasyModel.order_duration(start_date, end_date)
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      report = EasyReport::Report.new data, 'order_duration.yml'
      send_data report.render, :filename => "duracion_de_orden_produccion.pdf", :type => "application/pdf"
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

  def total_per_recipe
    start_date = EasyModel.parse_date(params[:report], 'start')
    end_date = EasyModel.parse_date(params[:report], 'end')
    data = EasyModel.total_per_recipe(start_date, end_date, params[:report][:recipe])
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      report = EasyReport::Report.new data, 'total_per_recipe.yml'
      send_data report.render, :filename => "consumo_por_receta.pdf", :type => "application/pdf"
    end
  end

  def consumption_per_ingredients
    start_date = EasyModel.parse_date(params[:report], 'start')
    end_date = EasyModel.parse_date(params[:report], 'end')
    data = EasyModel.consumption_per_ingredients(start_date, end_date)
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      report = EasyReport::Report.new data, 'consumption_per_ingredients.yml'
      send_data report.render, :filename => "consumo_por_ingredientes.pdf", :type => "application/pdf"
    end
  end

  def consumption_per_client
    start_date = EasyModel.parse_date(params[:report], 'start')
    end_date = EasyModel.parse_date(params[:report], 'end')
    data = EasyModel.consumption_per_client(start_date, end_date, params[:report][:client])
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      report = EasyReport::Report.new data, 'consumption_per_client.yml'
      send_data report.render, :filename => "consumo_por_cliente.pdf", :type => "application/pdf"
    end
  end

  def adjusments
    #start_date = EasyModel.parse_date(params[:report], 'start')
    start_date = EasyModel.param_to_date(params[:report], 'start')
    #end_date = EasyModel.parse_date(params[:report], 'end')
    end_date = EasyModel.param_to_date(params[:report], 'end')

    data = EasyModel.adjusments(start_date, end_date)
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      report = EasyReport::Report.new data, 'adjusments.yml'
      send_data report.render, :filename => "ajustes.pdf", :type => "application/pdf"
    end
  end

  def lots_incomes
    start_date = EasyModel.param_to_date(params[:report], 'start')
    end_date = EasyModel.param_to_date(params[:report], 'end')
    data = EasyModel.lots_incomes(start_date, end_date)
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      report = EasyReport::Report.new data, 'lots_incomes.yml'
      send_data report.render, :filename => "entrada_materia_prima.pdf", :type => "application/pdf"
    end
  end

  def ingredients_stock
    start_date = EasyModel.parse_date(params[:report], 'start')
    end_date = EasyModel.parse_date(params[:report], 'end')
    data = EasyModel.ingredients_stock(start_date, end_date)
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      report = EasyReport::Report.new data, 'ingredients_stock.yml'
      send_data report.render, :filename => "inventario_materia_prima.pdf", :type => "application/pdf"
    end
  end

  def product_lots_dispatches
    start_date = EasyModel.param_to_date(params[:report], 'start')
    end_date = EasyModel.param_to_date(params[:report], 'end')
    data = EasyModel.product_lots_dispatches(start_date, end_date)
    if data.nil?
      flash[:notice] = 'No hay registros para generar el reporte'
      flash[:type] = 'warn'
      redirect_to :action => 'index'
    else
      report = EasyReport::Report.new data, 'product_lots_dispatches.yml'
      send_data report.render, :filename => "despachos_producto_terminado.pdf", :type => "application/pdf"
    end
  end

  private

  def retard_report
    flash[:notice] = 'No hay registros para generar el reporte'
    flash[:type] = 'warn'
    redirect_to :action => 'index'
  end
end
