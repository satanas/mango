class EasyModel
  def self.recipes
    data = {}
    data['title'] = 'Reporte de recetas'
    data['table1'] = []
    @recipes = Recipe.find :all, :include => {:ingredient_recipe => :ingredient}
    return nil if @recipes.length.zero?
    @recipes.each do |r|
      receta = "Receta: #{r.code} - #{r.name} Version: #{r.version}"
      r.ingredient_recipe.each do |ing|
        data['table1'] << {
          'recipe' => receta,
          'code' => ing.ingredient.code,
          'name' => ing.ingredient.name,
          'amount' => ing.amount.to_s,
          'priority' => ing.priority.to_s,
          'percentage' => ing.percentage.to_s
        }
      end
    end
    data['total'] = "Recetas procesadas: #{Recipe.count}"
    return data
  end

  def self.daily_production(start_date, end_date)
    @orders = Order.find :all, :include=>['batch', 'recipe', 'client'], :conditions=>['batches.end >= ? and batches.end <= ?', start_date, end_date]
    return nil if @orders.length.zero?
    data = {}
    data['title'] = "Reporte de Produccion Diaria por Fabrica"
    data['results'] = []
    @orders.each do |o|
      data['results'] << {
        'order' => o.code,
        'recipe_code' => o.recipe.code,
        'recipe_name' => o.recipe.name,
        'client_code' => o.client.code,
        'client_name' => o.client.name,
        'real_batches' => o.real_batchs.to_s,
        'total_recipe' => o.recipe.total.to_s,
        'total_real' => o.total.to_s,
      }
    end
    return data
  end

=begin
  def self.order_details(start_date, end_date)
    @batches = Batch.find :all, :conditions => ['start >= ? and end <= ?', start_date, end_date], :order => '
    return nil if @batches.length.zero?
    data = {}
    data['title'] = 'Detalle Orden de Producción'
    
  end
=end
  #==== Utilities ====
  def self.parse_date(param, name)
    day = param["#{name}(1i)"].to_i
    month = param["#{name}(2i)"].to_i
    year = param["#{name}(3i)"].to_i
    return Date.new(day, month, year).strftime("%Y-%m-%d")
  end
end
