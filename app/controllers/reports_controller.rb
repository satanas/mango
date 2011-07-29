class ReportsController < ApplicationController
  def index
  end

  def recipes
    data = EasyModel.recipes
    report = EasyReport::Report.new data, 'recipes.yml'
    send_data report.render, :filename => "recetas.pdf", :type => "application/pdf" #, :disposition => 'inline'
  end
end
