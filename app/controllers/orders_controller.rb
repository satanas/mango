class OrdersController < ApplicationController
  def index
    @orders = []
  end

  def new
    @recipes = Recipe.find :all, :order => 'name ASC'
    @clients = Client.find :all, :order => 'name ASC'
    @users = User.find :all, :order => 'name ASC'
    @products = Product.find :all, :order => 'name ASC'
  end

  def create
    puts params.inspect
  end
end
