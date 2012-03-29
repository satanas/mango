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
    start_date << " 00:00:00"
    end_date << " 23:59:59"
    @orders = Order.find :all, :include=>['batch', 'recipe', 'client'], :conditions=>['batches.start_date >= ? and batches.end_date <= ?', start_date, end_date]
    return nil if @orders.length.zero?
    data = {}
    data['since'] = "Desde: #{Date.parse(start_date).strftime("%d/%m/%Y")}"
    data['until'] = "Hasta: #{Date.parse(end_date).strftime("%d/%m/%Y")}"
    std_total = 0
    real_total = 0
    data['results'] = []
    @orders.each do |o|
      rtotal = Batch.get_real_total(o.id)
      rbatches = Batch.get_real_batches(o.id)
      stotal = o.recipe.get_total() * rbatches
      data['results'] << {
        'order' => o.code,
        'recipe_code' => o.recipe.code,
        'recipe_name' => o.recipe.name,
        'client_code' => o.client.code,
        'client_name' => o.client.name,
        'real_batches' => rbatches.to_s,
        'total_standard' => stotal.to_s,
        'total_real' => rtotal.to_s,
      }
    end
    return data
  end
  
  def self.order_duration(start_date, end_date)
    start_date << " 00:00:00"
    end_date << " 23:59:59"
    @orders = Order.find :all, :include=>['batch', 'recipe', 'client'], :conditions=>['batches.start_date >= ? and batches.end_date <= ?', start_date, end_date]
    return nil if @orders.length.zero?
    data = {}
    data['since'] = "Desde: #{Date.parse(start_date).strftime("%d/%m/%Y")}"
    data['until'] = "Hasta: #{Date.parse(end_date).strftime("%d/%m/%Y")}"
    std_total = 0
    real_total = 0
    data['results'] = []
    @orders.each do |o|
      rtotal = Batch.get_real_total(o.id)
      rbatches = Batch.get_real_batches(o.id)
      stotal = o.recipe.get_total() * rbatches
      d = o.calculate_duration
      order_duration = d['duration']
      start_time = d['start_date'][-8,5] # Risky parsing
      end_time = d['end_date'][-8,5] # Risky parsing
      average_batch_duration = order_duration / rbatches # Must avoid divition by zero
      average_tons_per_hour = rtotal / (order_duration / 60) / 1000 # Must avoid divition by zero
      data['results'] << {
        'order' => o.code,
        'recipe_code' => o.recipe.code,
        'recipe_name' => o.recipe.name,
        'average_tons_per_hour' => average_tons_per_hour.to_s,
        'average_batch_duration' => average_batch_duration.to_s,
        'order_duration' => order_duration.to_s,
        'real_batches' => rbatches.to_s,
        'start_time' => start_time,
        'end_time' => end_time,
        'total_real' => rtotal.to_s,
        'total_standard' => stotal.to_s        
      }
    end
    return data
  end

  def self.order_details(order)
    @order = Order.find_by_code order, :include=>{:batch=>{:batch_hopper_lot=>{:hopper_lot=>{:hopper=>{}, :lot=>{:ingredient=>{}}}}}, :recipe=>{:ingredient_recipe=>{:ingredient=>{}}}, :product=>{}}, :conditions => ['lots.ingredient_id = ingredients_recipes.ingredient_id']

    return nil if @order.nil?
    data = {}
    ingredients = {}
    @order.recipe.ingredient_recipe.each do |ir|
      ingredients[ir.ingredient.code] = {
        'amount' => ir.amount.to_f,
      }
    end

    details = {}
    total_real = 0
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
            'var_kg' => 0,
            'var_perc' => 0
          }
        else
          details[key]['real_kg'] += bhl.amount.to_f
        end
        details[key]['std_kg'] = ingredients[key]['amount'] * @order.prog_batches
        total_real += details[key]['real_kg']
        details[key]['var_kg'] = details[key]['real_kg'] - details[key]['std_kg']
        details[key]['var_perc'] = details[key]['var_kg'] * 100 / details[key]['std_kg']
      end
    end

    data['order'] = @order.code
    data['recipe'] = "#{@order.recipe.code} - #{@order.recipe.name}"
    data['product'] = "#{@order.product.code} - #{@order.product.name}"
    data['start_date'] = @order.calculate_start_date()
    data['end_date'] = @order.calculate_end_date()
    data['prog_batches'] = @order.prog_batches.to_s
    data['real_batches'] = @order.get_real_batches().to_s
    data['product_total'] = "#{Batch.get_real_total(@order.id).to_s} Kg"
    data['total_real_kg'] = total_real

    data['results'] = []
    details.each do |key, value|
      element = {'code' => key}
      data['results'] << element.merge(value)
    end
    return data
  end

  def self.ingredients_variation(start_date, end_date)
    data = {}
    results = {}
    batches = BatchHopperLot.find :all, :include=>{:hopper_lot=>{:lot=>{:ingredient=>{}}}, :batch=>{:order=>{:recipe=>{:ingredient_recipe=>{:ingredient=>{}}}}}}, :conditions=>["batches.start_date >= '#{start_date}' AND batches.end_date <= '#{end_date}' AND lots.ingredient_id = ingredients_recipes.ingredient_id"]

    batches.each do |b|
      real_kg = b.amount.to_f
      std_kg = -1
      b.batch.order.recipe.ingredient_recipe.each do |i|
        if i.ingredient.id == b.hopper_lot.lot.ingredient.id
          std_kg = i.amount.to_f
          break
        end
      end

      if results.has_key?(b.hopper_lot.lot.code)
        results['real_kg'] += real_kg
        results['std_kg'] += std_kg
        results['var_kg'] = results['real_kg'] - results['std_kg']
        results['var_perc'] = results['var_kg'] * 100 / results['std_kg']
      else
        var_kg = real_kg - std_kg
        var_perc = var_kg * 100 / std_kg
        results[b.hopper_lot.lot.code] = {
          'lot' => b.hopper_lot.lot.code,
          'ingredient_code' => b.hopper_lot.lot.ingredient.code,
          'ingredient_name' => b.hopper_lot.lot.ingredient.name,
          'real_kg' => real_kg,
          'std_kg' => std_kg,
          'var_kg' => var_kg,
          'var_perc' => var_perc
        }
      end
    end

    temp = []
    results.each do |key, item|
      temp << item
    end
    data['title'] = 'Variacion de Materia Prima'
    data['start_date'] = start_date
    data['end_date'] = end_date
    data['results'] = temp
    return data
  end

  def self.batch_details(order_code, batch_number)
    data = {}
    results = []
    batches = BatchHopperLot.find :all, :include=>{:batch=>{:order=>{:recipe=>{:ingredient_recipe=>{:ingredient=>{}}}}}, :hopper_lot=>{:hopper=>{}, :lot=>{:ingredient=>{}}}}, :conditions=>["batches.number = '#{batch_number}' AND orders.code = '#{order_code}' AND lots.ingredient_id = ingredients_recipes.ingredient_id"]

    batches.each do |b|
      real_kg = b.amount.to_f
      std_kg = -1
      b.batch.order.recipe.ingredient_recipe.each do |i|
        if i.ingredient.id == b.hopper_lot.lot.ingredient.id
          std_kg = i.amount.to_f
          break
        end
      end
      var_kg = real_kg - std_kg
      var_perc = var_kg * 100 / std_kg
      results << {
        'code' => b.hopper_lot.lot.ingredient.code,
        'ingredient' => b.hopper_lot.lot.ingredient.name,
        'real_kg' => real_kg,
        'std_kg' => std_kg,
        'var_kg' => var_kg,
        'var_perc' => var_perc,
        'hopper' => b.hopper_lot.hopper.number,
        'lot' => b.hopper_lot.lot.code,
      }
      data['recipe'] = "#{b.batch.order.recipe.code} - #{b.batch.order.recipe.name}"
    end

    order = Order.find_by_code(order_code)
    data['order'] = order_code
    data['batch'] = batch_number
    data['start_date'] = Batch.where(:order_id=>order.id).minimum('start_date').strftime("%d/%m/%Y %H:%M:%S")
    data['end_date'] = Batch.where(:order_id=>order.id).maximum('end_date').strftime("%d/%m/%Y %H:%M:%S")
    data['results'] = results
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
