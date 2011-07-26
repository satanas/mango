class ReportsController < ApplicationController
  def index
  end

  def ingredients
    data = {}
    data['config_file'] = 'base.yml'
    data['subtitle'] = 'Reporte de prueba'
    data['footer'] = 'Otro texto mas'
    data['table_title'] = 'Ingredientes'
    data['columns'] = ['codigo', 'nombre']
    data['data'] = []
    @ingredients = Ingredient.find :all
    @ingredients.each do |ing|
      data['data'] << {
        'codigo' => ing.code,
        'nombre' => ing.name
      }
    end
    report = EasyReport.new data
    send_data report.render, :filename => "hello.pdf", :type => "application/pdf" #, :disposition => 'inline'
  end
end
