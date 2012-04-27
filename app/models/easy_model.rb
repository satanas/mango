class EasyModel

  def self.recipes
    @recipes = Recipe.find :all, :include => {:ingredient_recipe => :ingredient}
    return nil if @recipes.length.zero?

    data = self.initialize_data('Recetas')
    data['table1'] = []

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

    data = self.initialize_data('Produccion Diaria por Fabrica')
    data['since'] = "Desde: #{Date.parse(start_date).strftime("%d/%m/%Y")}"
    data['until'] = "Hasta: #{Date.parse(end_date).strftime("%d/%m/%Y")}"
    data['results'] = []

    std_total = 0
    real_total = 0
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
        'var_kg' => (stotal - rtotal).to_s,
        'var_perc' => ((rtotal * 100.0) / stotal).to_s
      }
    end

    return data
  end

  def self.order_duration(start_date, end_date)
    start_date << " 00:00:00"
    end_date << " 23:59:59"
    @orders = Order.find :all, :include=>['batch', 'recipe', 'client'], :conditions=>['batches.start_date >= ? and batches.end_date <= ?', start_date, end_date]
    return nil if @orders.length.zero?

    data = self.initialize_data('Duracion de Orden de Produccion')
    data['since'] = "Desde: #{Date.parse(start_date).strftime("%d/%m/%Y")}"
    data['until'] = "Hasta: #{Date.parse(end_date).strftime("%d/%m/%Y")}"
    data['results'] = []

    std_total = 0
    real_total = 0
    @orders.each do |o|
      rtotal = Batch.get_real_total(o.id)
      rbatches = Batch.get_real_batches(o.id)
      stotal = o.recipe.get_total() * rbatches
      d = o.calculate_duration
      order_duration = d['duration']
      start_time = d['start_date'][-8,5] # Risky parsing
      end_time = d['end_date'][-8,5] # Risky parsing
      average_batch_duration = order_duration / rbatches rescue 0
      average_tons_per_hour = rtotal / (order_duration / 60) / 1000 rescue 0
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
    @order = Order.find_by_code order, :include=>{:batch=>{:batch_hopper_lot=>{:hopper_lot=>{:hopper=>{}, :lot=>{:ingredient=>{}}}}}, :recipe=>{:ingredient_recipe=>{:ingredient=>{}}}, :product_lot=>{:product=>{}}}, :conditions => ['lots.ingredient_id = ingredients_recipes.ingredient_id']
    return nil if @order.nil?

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

    data = self.initialize_data('Detalle de Orden de Produccion')
    data['order'] = @order.code
    data['recipe'] = "#{@order.recipe.code} - #{@order.recipe.name}"
    data['product'] = "#{@order.product_lot.product.code} - #{@order.product_lot.product.name}"
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

  def self.batch_details(order_code, batch_number)
    order = Order.find_by_code(order_code)

    data = self.initialize_data('Detalle de Batch')
    data['order'] = order_code
    data['batch'] = batch_number
    data['start_date'] = Batch.where(:order_id=>order.id).minimum('start_date').strftime("%d/%m/%Y %H:%M:%S")
    data['end_date'] = Batch.where(:order_id=>order.id).maximum('end_date').strftime("%d/%m/%Y %H:%M:%S")
    data['results'] = []

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
      data['results'] << {
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

    return data
  end

  def self.consumption_per_recipe(start_date, end_date, recipe_code)
    start_date << " 00:00:00"
    end_date << " 23:59:59"

    recipe = Recipe.find :first, :include=>{:ingredient_recipe=>{:ingredient=>{}}}, :conditions => ['code = ?', recipe_code]
    return nil if recipe.nil?

    std = {}
    real = {}
    nominal = {}

    data = self.initialize_data('Consumo por Receta')
    data['recipe'] = "#{recipe.code} - #{recipe.name}"
    data['start_date'] = start_date
    data['end_date'] = end_date
    data['results'] = []

    recipe.ingredient_recipe.each do |ir|
      key = ir.ingredient.code
      nominal[key] = [ir.ingredient.name, ir.amount]
    end

    orders = Order.find :all, :include=>{:batch=>{:batch_hopper_lot=>{:hopper_lot=>{:lot=>{:ingredient=>{}}}}}}, :conditions => ["batches.start_date >= '#{start_date}' AND batches.end_date <= '#{end_date}' AND recipe_id = ?", recipe.id]

    orders.each do |o|
      o.batch.each do |b|
        b.batch_hopper_lot.each do |bhl|
          key = bhl.hopper_lot.lot.ingredient.code
          value = bhl.amount

          std[key] = std.fetch(key, 0) + nominal[key][1]
          real[key] = real.fetch(key, 0) + value
        end
      end
    end

    nominal.each do |key, value|
      data['results'] << {
        'code' => key,
        'ingredient' => value[0],
        'std_kg' => std[key].to_s,
        'real_kg' => real[key].to_s,
      }
    end

    return data
  end

  def self.stock_adjustments(start_date, end_date)
    transaction_types = TransactionType.find :all
    adjustment_type_ids = []
    transaction_types.each do |ttype|
      unless ttype.code.match(/(?i)AJU/).nil?
        puts "Adjusment code found: " + ttype.code
        adjustment_type_ids << ttype.id
      end
    end
    return nil if adjustment_type_ids.length.zero?

    adjustments = Transaction.find :all, :conditions => {:transaction_type_id => adjustment_type_ids,
                                                        :date => (start_date)..((end_date) + 1.day)}
    return nil if adjustments.length.zero?

    data = self.initialize_data('Ajustes de Inventario')
    data['since'] = "Desde: #{start_date.strftime("%d/%m/%Y")}"
    data['until'] = "Hasta: #{end_date.strftime("%d/%m/%Y")}"
    data['results'] = []

    adjustments.each do |a|
      warehouse = Warehouse.find(a.warehouse_id)
      lot_code = ''
      content_code = ''
      content_name = ''
      if warehouse.warehouse_type_id == 1 # ING Warehouse
        lot = Lot.find(warehouse.content_id)
        lot_code = lot.code
        content_code = Ingredient.find(lot.ingredient_id).code
        content_name = Ingredient.find(lot.ingredient_id).name
      else # PDT Warehouse
        product_lot = ProductLot.find(warehouse.content_id)
        lot_code = product_lot.code
        content_code = Product.find(product_lot.product_id).code
        content_name = Product.find(product_lot.product_id).name
      end
      transaction_type_id = a.transaction_type_id
      sign = TransactionType.find(transaction_type_id).sign
      ttype_code = TransactionType.find(transaction_type_id).code
      amount = a.amount
      if sign == '-'
        amount = -1 * amount
      end

      user_name = User.find(a.user_id).name
      date = a.date.strftime("%Y-%m-%d")

      data['results'] << {
        'lot_code' => lot_code,
        'content_code' => content_code,
        'content_name' => content_name,
        'amount' => amount.to_s,
        'user_name' => user_name,
        'date' => date,
        'adjustment_code' => ttype_code
      }
    end

    return data
  end

  def self.consumption_per_ingredients(start_date, end_date)
    start_date << " 00:00:00"
    end_date << " 23:59:59"

    data = self.initialize_data('Consumo por Ingrediente')
    data['results'] = []
    data['start_date'] = start_date
    data['end_date'] = end_date

    real = {}
    name = {}
    orders = Order.find :all, :include=>{:batch=>{:batch_hopper_lot=>{:hopper_lot=>{:lot=>{:ingredient=>{}}}}}}, :conditions => ["batches.start_date >= '#{start_date}' AND batches.end_date <= '#{end_date}'"]

    orders.each do |o|
      o.batch.each do |b|
        b.batch_hopper_lot.each do |bhl|
          key = bhl.hopper_lot.lot.ingredient.code
          name[key] = bhl.hopper_lot.lot.ingredient.name
          real[key] = real.fetch(key, 0) + bhl.amount
        end
      end
    end

    real.each do |key, value|
      data['results'] << {
        'code' => key,
        'ingredient' => name[key],
        'real_kg' => value.to_s,
      }
    end

    return data
  end

  def self.consumption_per_client(start_date, end_date, client_code)
    start_date << " 00:00:00"
    end_date << " 23:59:59"

    client = Client.find :first, :conditions => ['code = ?', client_code]

    data = self.initialize_data('Consumo por Cliente')
    data['client'] = "#{client.code} - #{client.name}"
    data['start_date'] = start_date
    data['end_date'] = end_date
    data['results'] = []

    real = {}
    name = {}
    orders = Order.find :all, :include=>{:batch=>{:batch_hopper_lot=>{:hopper_lot=>{:lot=>{:ingredient=>{}}}}}}, :conditions => ["batches.start_date >= '#{start_date}' AND batches.end_date <= '#{end_date}' AND orders.client_id = ?", client.id]

    orders.each do |o|
      o.batch.each do |b|
        b.batch_hopper_lot.each do |bhl|
          key = bhl.hopper_lot.lot.ingredient.code
          name[key] = bhl.hopper_lot.lot.ingredient.name
          real[key] = real.fetch(key, 0) + bhl.amount
        end
      end
    end

    real.each do |key, value|
      data['results'] << {
        'code' => key,
        'ingredient' => name[key],
        'real_kg' => value.to_s,
      }
    end

    return data
  end

  # Modularization will do great things... when we get the time
  def self.lots_incomes(start_date, end_date)
    income_type = TransactionType.find :first, :conditions => {:code => 'EN-COM'}
    "Income code found: " + income_type.code
    return nil if income_type.nil?

    # We should leave out product warehouses here using :include, the pulidito way.
    incomes = Transaction.find :all, :include=>[:user], :conditions => {:transaction_type_id => income_type, :date => (start_date)..((end_date) + 1.day)}
    return nil if incomes.length.zero?

    data = self.initialize_data('Entradas de Materia Prima')
    data['since'] = "Desde: #{start_date.strftime("%d/%m/%Y")}"
    data['until'] = "Hasta: #{end_date.strftime("%d/%m/%Y")}"
    data['results'] = []

    incomes.each do |i|
      warehouse = Warehouse.find(i.warehouse_id)
      lot_code = ''
      content_code = ''
      content_name = ''
      if warehouse.warehouse_type_id == 1 # The not so pulidito way.
        lot = Lot.find(warehouse.content_id)
        lot_code = lot.code
        content_code = Ingredient.find(lot.ingredient_id).code
        content_name = Ingredient.find(lot.ingredient_id).name
        transaction_type_id = i.transaction_type_id
        sign = TransactionType.find(transaction_type_id).sign
        ttype_code = TransactionType.find(transaction_type_id).code
        amount = i.amount
        if sign == '-'
          amount = -1 * amount
        end

        #user_name = User.find(i.user_id).name
        date = i.date.strftime("%Y-%m-%d")

        data['results'] << {
          'lot_code' => lot_code,
          'content_code' => content_code,
          'content_name' => content_name,
          'amount' => amount.to_s,
          'user_name' => i.user.login,
          'date' => date,
          'adjusment_code' => ttype_code
        }
      end
    end

    return data
  end

  def self.ingredients_stock(start_date, end_date)
    start_date << " 00:00:00"
    end_date << " 23:59:59"

    stock = {}
    data = self.initialize_data('Inventario de Materia Prima')
    data['start_date'] = start_date
    data['end_date'] = end_date
    data['results'] = []

    transactions = Transaction.find :all, :include=>{:warehouse=>{}, :transaction_type=>{}}, :conditions=>["transactions.date >= '#{start_date}' AND transactions.date <= '#{end_date}' AND warehouses.warehouse_type_id=1"]
    transactions.each do |t|
      income = 0
      outcome = 0
      ingredient = t.warehouse.get_content.ingredient

      if t.transaction_type.sign == '+'
        income = t.amount
      elsif t.transaction_type.sign == '-'
        outcome = t.amount
      end

      if stock.has_key?(ingredient.code)
        stock[ingredient.code]['income'] += income
        stock[ingredient.code]['outcome'] += outcome
        stock[ingredient.code]['stock'] = stock[ingredient.code]['income'] - stock[ingredient.code]['outcome']
      else
        stock[ingredient.code] = {
          'code' => ingredient.code,
          'name' => ingredient.name,
          'income' => income,
          'outcome' => outcome,
          'stock' => (income - outcome)
        }
      end
    end

    stock.each do |key, value|
      data['results'] << {
        'code' => value['code'],
        'ingredient' => value['name'],
        'income_kg' => value['income'].to_s,
        'outcome_kg' => value['outcome'].to_s,
        'stock_kg' => value['stock'].to_s,
      }
    end

    return data
  end

  def self.product_lots_dispatches(start_date, end_date)
    dispatch_type = TransactionType.find :first, :conditions => {:code => 'SA-DES'}
    return nil if dispatch_type.nil?

    # We should leave out ingredient warehouses here using :include, the pulidito way.
    dispatches = Transaction.find :all, :conditions => {:transaction_type_id => dispatch_type, :date => (start_date)..((end_date) + 1.day)}
    return nil if dispatches.length.zero?

    data = self.initialize_data('Inventario de Materia Prima')
    data['since'] = "Desde: #{start_date.strftime("%d/%m/%Y")}"
    data['until'] = "Hasta: #{end_date.strftime("%d/%m/%Y")}"
    data['results'] = []

    dispatches.each do |d|
      warehouse = Warehouse.find(d.warehouse_id)
      lot_code = ''
      content_code = ''
      content_name = ''
      if warehouse.warehouse_type_id == 2 # The not so pulidito way.
        product_lot = ProductLot.find(warehouse.content_id)
        lot_code = product_lot.code
        content_code = Product.find(product_lot.product_id).code
        content_name = Product.find(product_lot.product_id).name
        transaction_type_id = d.transaction_type_id
        ttype_code = TransactionType.find(transaction_type_id).code
        amount = d.amount

        user_name = User.find(d.user_id).name
        date = d.date.strftime("%Y-%m-%d")

        data['results'] << {
          'lot_code' => lot_code,
          'content_code' => content_code,
          'content_name' => content_name,
          'amount' => amount.to_s,
          'user_name' => user_name,
          'date' => date,
          'adjusment_code' => ttype_code
        }
      end
    end

    return data
  end

  # ================================================================
  # Utilities
  # ================================================================

  def self.parse_date(param, name)
    day = param["#{name}(1i)"].to_i
    month = param["#{name}(2i)"].to_i
    year = param["#{name}(3i)"].to_i
    return Date.new(day, month, year).strftime("%Y-%m-%d")
  end

  def self.param_to_date(param, name)
    day = param["#{name}(1i)"].to_i
    month = param["#{name}(2i)"].to_i
    year = param["#{name}(3i)"].to_i
    return Date.new(day, month, year)
  end

  private

  def self.initialize_data(title)
    company = YAML::load(File.open("#{Rails.root.to_s}/config/global.yml"))['application']
    puts company.inspect
    data = {}
    data['title'] = title
    data['company_name'] = company['name']
    data['company_address'] = company['address']
    data['company_rif'] = company['rif']
    data['company_logo'] = company['logo']
    data['footer'] = company['footer']

    return data
  end
end
