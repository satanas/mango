class ReportsController < ApplicationController
  def index
  end

  def ingredients
    @ingredients = Ingredient.find :all
    send_data _pdf.render, :filename => "hello.pdf", :type => "application/pdf" #, :disposition => 'inline'
  end
end
