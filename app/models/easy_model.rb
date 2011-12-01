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
    @orders = Order.find :all, :include=>['batch', 'recipe', 'client'], :conditions=>['batches.end_date >= ? and batches.end_date <= ?', start_date, end_date]
    return nil if @orders.length.zero?
    data = {}
    data['title'] = "Reporte de Produccion Diaria por Fabrica"
    data['since'] = "Desde: #{Date.parse(start_date).strftime("%d/%m/%Y")}"
    data['until'] = "Hasta: #{Date.parse(end_date).strftime("%d/%m/%Y")}"
    std_total = 0
    real_total = 0
    data['results'] = []
    @orders.each do |o|
      rtotal = Batch.get_real_total(o.id)
      data['results'] << {
        'order' => o.code,
        'recipe_code' => o.recipe.code,
        'recipe_name' => o.recipe.name,
        'client_code' => o.client.code,
        'client_name' => o.client.name,
        'real_batches' => Batch.get_real_batches(o.id).to_s,
        'total_recipe' => o.recipe.total.to_s,
        'total_real' => rtotal.to_s,
      }
    end
    return data
  end

  def self.order_details(order)
    @order = Order.find_by_code order, :include=>[
        {:batch=>{:batch_hopper_lot=>{:hopper_lot=>[:hopper, {:lot=>:ingredient}]}}},
        {:recipe=>{:ingredient_recipe=>:ingredient}},
        :product
      ]
    return nil if @order.nil?
    data = {}
    data['title'] = 'Detalle Orden de Produccion'
    ingredients = {}
    @order.recipe.ingredient_recipe.each do |ir|
      ingredients[ir.ingredient.code] = {
        'amount' => ir.amount.to_f,
      }
    end

    data['recipe'] = "#{@order.recipe.code} - #{@order.recipe.name}"
    data['product'] = "#{@order.product.code} - #{@order.product.name}"
    data['start_date'] = Batch.where(:order_id=>@order.id).minimum('start_date').strftime("%d/%m/%Y %H:%M:%S")
    data['end_date'] = Batch.where(:order_id=>@order.id).maximum('end_date').strftime("%d/%m/%Y %H:%M:%S")
    data['prog_batches'] = @order.prog_batches.to_s
    data['real_batches'] = @order.real_batches.to_s
    data['product_total'] = "#{Batch.get_real_total(@order.id).to_s} Kg"

    details = {}
    total_real = 0
    #total_std = 0
    #total_var = 0
    @order.batch.each do |batch|
      batch.batch_hopper_lot.each do |bhl|
        key = bhl.hopper_lot.lot.ingredient.code
        std_amount = (ingredients.has_key?(key)) ? ingredients[key]['amount'] : 0
        unless details.has_key?(key)
          details[key] = {
            'ingredient' => bhl.hopper_lot.lot.ingredient.name,
            'lot' => bhl.hopper_lot.lot.code,
            'hopper' => bhl.hopper_lot.hopper.number,
            'real_kg' => bhl.amount.to_f,
            'std_kg' => std_amount,
            'var_kg' => 0
          }
        else
          details[key]['real_kg'] += bhl.amount.to_f
          details[key]['std_kg'] += ingredients[key]['amount']
        end
        total_real += details[key]['real_kg']
        details[key]['var_kg'] = details[key]['real_kg'] - details[key]['std_kg']
      end
    end

    data['total_real_kg'] = total_real
    data['results'] = []
    details.each do |key, value|
      element = {'code' => key}
      data['results'] << element.merge(value)
    end
    return data
  end

  #==== Utilities ====
  def self.parse_date(param, name)
    day = param["#{name}(1i)"].to_i
    month = param["#{name}(2i)"].to_i
    year = param["#{name}(3i)"].to_i
    return Date.new(day, month, year).strftime("%Y-%m-%d")
  end
end
