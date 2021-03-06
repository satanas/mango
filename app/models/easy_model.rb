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
    @orders = Order.find :all, :include=>['batch', 'recipe', 'client'], :conditions=>['batches.start_date >= ? and batches.end_date <= ?', self.start_date_to_sql(start_date), self.end_date_to_sql(end_date)], :order=>['batches.start_date DESC']
    return nil if @orders.length.zero?

    data = self.initialize_data('Produccion Diaria por Fabrica')
    data['since'] = self.print_range_date(start_date)
    data['until'] = self.print_range_date(end_date)
    data['results'] = []

    std_total = 0
    real_total = 0
    @orders.each do |o|
      rtotal = Batch.get_real_total(o.id)
      rbatches = Batch.get_real_batches(o.id)
      stotal = o.recipe.get_total() * rbatches
      var_kg = stotal - rtotal
      var_perc = (rtotal * 100.0) / stotal
      if var_perc > 100:
        var_perc = 100 - var_perc
      end
      data['results'] << {
        'order' => o.code,
        'date' => self.print_formatted_date(o.created_at),
        'recipe_code' => o.recipe.code,
        'recipe_name' => o.recipe.name,
        'client_code' => o.client.code,
        'client_name' => o.client.name,
        'real_batches' => rbatches.to_s,
        'total_standard' => stotal.to_s,
        'total_real' => rtotal.to_s,
        'var_kg' => var_kg.to_s,
        'var_perc' => var_perc.to_s
      }
    end

    return data
  end

  def self.order_duration(start_date, end_date)
    @orders = Order.find :all, :include=>['batch', 'recipe', 'client'], :conditions=>['batches.start_date >= ? and batches.end_date <= ?', self.start_date_to_sql(start_date), self.end_date_to_sql(end_date)], :order=>['batches.start_date DESC']
    return nil if @orders.length.zero?

    data = self.initialize_data('Duracion de Orden de Produccion')
    data['since'] = self.print_range_date(start_date)
    data['until'] = self.print_range_date(end_date)
    data['results'] = []

    std_total = 0
    real_total = 0
    @orders.each do |o|
      rtotal = Batch.get_real_total(o.id)
      rbatches = Batch.get_real_batches(o.id)
      stotal = o.recipe.get_total() * rbatches
      d = o.calculate_duration
      order_duration = d['duration']
      start_time = d['start_date']
      end_time = d['end_date']
      average_batch_duration = order_duration / rbatches rescue 0
      average_tons_per_hour = rtotal / (order_duration / 60) / 1000 rescue 0
      data['results'] << {
        'order' => o.code,
        'date' => self.print_formatted_date(o.created_at),
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
            'var_perc' => 0,
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
    data['version'] = @order.recipe.version
    data['comment'] = @order.comment
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
    return nil if order.nil?

    batch = Batch.find :first, :include=>[:order], :conditions=>{:number=>batch_number, :orders=>{:code=>order_code}}
    return nil if batch.nil?

    data = self.initialize_data('Detalle de Batch')
    data['order'] = order_code
    data['batch'] = batch_number
    data['start_date'] = self.print_range_date(batch.start_date, true)
    data['end_date'] = self.print_range_date(batch.end_date, true)
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
    recipe = Recipe.find :first, :include=>{:ingredient_recipe=>{:ingredient=>{}}}, :conditions => ['code = ?', recipe_code]
    return nil if recipe.nil?

    std = {}
    real = {}
    nominal = {}

    data = self.initialize_data('Consumo por Receta')
    data['recipe'] = "#{recipe.code} - #{recipe.name}"
    data['since'] = self.print_range_date(start_date)
    data['until'] = self.print_range_date(end_date)
    data['results'] = []

    recipe.ingredient_recipe.each do |ir|
      key = ir.ingredient.code
      nominal[key] = [ir.ingredient.name, ir.amount]
    end

    orders = Order.find :all, :include=>{:batch=>{:batch_hopper_lot=>{:hopper_lot=>{:lot=>{:ingredient=>{}}}}}}, :conditions => ["batches.start_date >= ? AND batches.end_date <= ? AND recipe_id = ?", self.start_date_to_sql(start_date), self.end_date_to_sql(end_date), recipe.id], :order=>['batches.start_date DESC']

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

  def self.consumption_per_ingredients(start_date, end_date)
    data = self.initialize_data('Consumo por Ingrediente')
    data['since'] = self.print_range_date(start_date)
    data['until'] = self.print_range_date(end_date)
    data['results'] = []

    results = {}
    batches = BatchHopperLot.find :all, :include=>{:hopper_lot=>{:lot=>{:ingredient=>{}}}, :batch=>{:order=>{:recipe=>{:ingredient_recipe=>{:ingredient=>{}}}}}}, :conditions => ["batches.start_date >= ? AND batches.end_date <= ? AND lots.ingredient_id = ingredients_recipes.ingredient_id", self.start_date_to_sql(start_date), self.end_date_to_sql(end_date)], :order=>['batches.start_date DESC'] #:conditions=>["batches.start_date >= '#{start_date}' AND batches.end_date <= '#{end_date}' AND lots.ingredient_id = ingredients_recipes.ingredient_id"]
    batches.each do |b|
      real_kg = b.amount.to_f
      std_kg = -1
      b.batch.order.recipe.ingredient_recipe.each do |i|
        if i.ingredient.id == b.hopper_lot.lot.ingredient.id
          std_kg = i.amount.to_f
          break
        end
      end

      key = b.hopper_lot.lot.code
      if results.has_key?(key)
        results[key]['real_kg'] += real_kg
        results[key]['std_kg'] += std_kg
        results[key]['var_kg'] = results[key]['real_kg'] - results[key]['std_kg']
        results[key]['var_perc'] = results[key]['var_kg'] * 100 / results[key]['std_kg']
      else
        var_kg = real_kg - std_kg
        var_perc = var_kg * 100 / std_kg
        results[key] = {
          'lot' => key,
          'ingredient_code' => b.hopper_lot.lot.ingredient.code,
          'ingredient_name' => b.hopper_lot.lot.ingredient.name,
          'real_kg' => real_kg,
          'std_kg' => std_kg,
          'var_kg' => var_kg,
          'var_perc' => var_perc
        }
      end
    end

    results.each do |key, item|
      data['results'] << item
    end

    return data
  end

  def self.consumption_per_client(start_date, end_date, client_code)
    client = Client.find :first, :conditions => ['code = ?', client_code]

    data = self.initialize_data('Consumo por Cliente')
    data['client'] = "#{client.code} - #{client.name}"
    data['since'] = self.print_range_date(start_date)
    data['until'] = self.print_range_date(end_date)
    data['results'] = []

    real = {}
    name = {}
    orders = Order.find :all, :include=>{:batch=>{:batch_hopper_lot=>{:hopper_lot=>{:lot=>{:ingredient=>{}}}}}}, :conditions => ["batches.start_date >= ? AND batches.end_date <= ? AND orders.client_id = ?", self.start_date_to_sql(start_date), self.end_date_to_sql(end_date), client.id], :order=>['batches.start_date DESC']

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

    adjustments = Transaction.find :all, :include=>[:warehouse, :user], :conditions => {:transaction_type_id => adjustment_type_ids, :date => (start_date)..((end_date) + 1.day)}, :order=>['date DESC']
    return nil if adjustments.length.zero?

    data = self.initialize_data('Ajustes de Inventario')
    data['since'] = self.print_range_date(start_date)
    data['until'] = self.print_range_date(end_date)
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

      data['results'] << {
        'lot_code' => lot_code,
        'content_code' => content_code,
        'content_name' => content_name,
        'amount' => amount.to_s,
        'user_name' => a.user.login,
        'date' => self.print_formatted_date(a.date),
        'adjustment_code' => ttype_code
      }
    end

    return data
  end

  def self.lots_incomes(start_date, end_date)
    income_type = TransactionType.find :first, :conditions => {:code => 'EN-COM'}
    "Income code found: " + income_type.code
    return nil if income_type.nil?

    incomes = Transaction.find :all, :include=>[:user], :conditions => {:transaction_type_id => income_type, :date => (start_date)..((end_date) + 1.day)}, :order=>['date DESC']
    return nil if incomes.length.zero?

    data = self.initialize_data('Entradas de Materia Prima')
    data['since'] = self.print_range_date(start_date)
    data['until'] = self.print_range_date(end_date)
    data['results'] = []

    incomes.each do |i|
      warehouse = Warehouse.find(i.warehouse_id)
      lot_code = ''
      content_code = ''
      content_name = ''
      if warehouse.warehouse_type_id == 1
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

        data['results'] << {
          'lot_code' => lot_code,
          'content_code' => content_code,
          'content_name' => content_name,
          'amount' => amount.to_s,
          'user_name' => i.user.login,
          'date' => self.print_formatted_date(i.date),
          'adjusment_code' => ttype_code
        }
      end
    end

    return data
  end

  def self.ingredients_stock(start_date, end_date)
    data = self.initialize_data('Inventario de Materia Prima')
    data['since'] = self.print_range_date(start_date)
    data['until'] = self.print_range_date(end_date)
    data['results'] = []

    stock = {}
    transactions = Transaction.find :all, :include=>{:warehouse=>{}, :transaction_type=>{}}, :conditions=>{:warehouses=>{:warehouse_type_id=>1}, :transactions=>{:date=>(start_date)..((end_date) + 1.day)}} , :order=>['date DESC']
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

  def self.product_lots_dispatches(start_date, end_date, doc_number)
    if doc_number.blank?
      conditions = {:transaction_type_id=>5, :date=>(start_date)..((end_date) + 1.day)}
    else
      conditions = {:transaction_type_id=>5, :transactions=>{:document_number=>doc_number}, :date=>(start_date)..((end_date) + 1.day)}
    end

    dispatches = Transaction.find :all, :include=>[:warehouse, :transaction_type, :user], :conditions => conditions, :order=>['date DESC']
    return nil if dispatches.length.zero?

    data = self.initialize_data('Despacho de producto terminado')
    data['since'] = self.print_range_date(start_date)
    data['until'] = self.print_range_date(end_date)
    data['results'] = []

    dispatches.each do |d|
      if d.warehouse.warehouse_type_id == 2
        product_lot = ProductLot.find d.warehouse.content_id, :include=>[:product]

        data['results'] << {
          'lot_code' => product_lot.code,
          'doc_number' => d.document_number || '--',
          'content_code' => product_lot.product.code,
          'content_name' => product_lot.product.name,
          'amount' => d.amount.to_s,
          'user_name' => d.user.login,
          'comment' => d.comment,
          'date' => self.print_formatted_date(d.date),
          'adjusment_code' => d.transaction_type.code,
        }
      end
    end
    return nil if data['results'].empty?
    return data
  end

  def self.products_stock(start_date, end_date)
    stock = {}
    data = self.initialize_data('Inventario de Producto Terminado')
    data['since'] = self.print_range_date(start_date)
    data['until'] = self.print_range_date(end_date)
    data['results'] = []

    transactions = Transaction.find :all, :include=>{:warehouse=>{}, :transaction_type=>{}}, :conditions=>{:date=>(start_date)..((end_date) + 1.day), :warehouses=>{:warehouse_type_id=>2}}, :order=>['date DESC']
    transactions.each do |t|
      income = 0
      outcome = 0
      product = t.warehouse.get_content.product

      if t.transaction_type.sign == '+'
        income = t.amount
      elsif t.transaction_type.sign == '-'
        outcome = t.amount
      end

      if stock.has_key?(product.code)
        stock[product.code]['income'] += income
        stock[product.code]['outcome'] += outcome
        stock[product.code]['stock'] = stock[product.code]['income'] - stock[product.code]['outcome']
      else
        stock[product.code] = {
          'code' => product.code,
          'name' => product.name,
          'income' => income,
          'outcome' => outcome,
          'stock' => (income - outcome)
        }
      end
    end

    stock.each do |key, value|
      data['results'] << {
        'code' => value['code'],
        'product' => value['name'],
        'income_kg' => value['income'].to_s,
        'outcome_kg' => value['outcome'].to_s,
        'stock_kg' => value['stock'].to_s,
      }
    end

    return data
  end

  def self.production_per_recipe(start_date, end_date, recipe_code)
    recipe = Recipe.find :first, :include=>{:ingredient_recipe=>{:ingredient=>{}}}, :conditions => ['code = ?', recipe_code]
    return nil if recipe.nil?

    data = self.initialize_data('Produccion por Receta')
    data['recipe'] = "#{recipe.code} - #{recipe.name}"
    data['since'] = self.print_range_date(start_date)
    data['until'] = self.print_range_date(end_date)
    data['results'] = []

    nominal = 0
    recipe.ingredient_recipe.each do |ir|
      nominal += ir.amount
    end

    orders = Order.find :all, :include=>{:batch=>{:batch_hopper_lot=>{:hopper_lot=>{:lot=>{:ingredient=>{}}}}}, :client=>{}}, :conditions => ["batches.start_date >= ? AND batches.end_date <= ? AND recipe_id = ?", self.start_date_to_sql(start_date), self.end_date_to_sql(end_date), recipe.id], :order=>['batches.start_date DESC']

    orders.each do |o|
      std = 0
      real = 0
      o.batch.each do |b|
        b.batch_hopper_lot.each do |bhl|
          std += nominal
          real += bhl.amount
        end
      end

      data['results'] << {
        'order' => o.code,
        'client_code' => o.client.ci_rif,
        'client_name' => o.client.name,
        'real_batches' => o.get_real_batches(),
        'std_kg' => std.to_s,
        'real_kg' => real.to_s,
      }
    end

    return data
  end

  def self.production_per_client(start_date, end_date, client_code)
    client = Client.find :first, :conditions => ['code = ?', client_code]
    return nil if client.nil?

    data = self.initialize_data('Produccion por Cliente')
    data['client'] = "#{client.ci_rif} - #{client.name}"
    data['since'] = self.print_range_date(start_date)
    data['until'] = self.print_range_date(end_date)
    data['results'] = []

    orders = Order.find :all, :include=>{:batch=>{:batch_hopper_lot=>{:hopper_lot=>{:lot=>{:ingredient=>{}}}}}, :recipe=>{:ingredient_recipe=>{:ingredient=>{}}}}, :conditions => ["batches.start_date >= ? AND batches.end_date <= ? AND client_id = ?", self.start_date_to_sql(start_date), self.end_date_to_sql(end_date), client.id], :order=>['batches.start_date DESC']

    orders.each do |o|
      std = 0
      real = 0
      nominal = 0

      o.recipe.ingredient_recipe.each do |ir|
        nominal += ir.amount
      end

      o.batch.each do |b|
        b.batch_hopper_lot.each do |bhl|
          std += nominal
          real += bhl.amount
        end
      end

      data['results'] << {
        'order' => o.code,
        'recipe_code' => o.recipe.code,
        'recipe_name' => o.recipe.name,
        'real_batches' => o.get_real_batches(),
        'std_kg' => std.to_s,
        'real_kg' => real.to_s,
      }
    end

    return data
  end

  # ================================================================
  # Utilities
  # ================================================================

  def self.param_to_date(param, name)
    day = param["#{name}(1i)"].to_i
    month = param["#{name}(2i)"].to_i
    year = param["#{name}(3i)"].to_i
    return Date.new(day, month, year)
  end

  def self.print_formatted_date(date)
    date.strftime("%d/%m/%Y")
  end

  def self.start_date_to_sql(date)
    date.strftime("%Y-%m-%d")
  end

  def self.end_date_to_sql(date)
    (date + 1.day).strftime("%Y-%m-%d")
  end

  def self.print_range_date(str_date, with_time=false)
    fmt = with_time ? "%d/%m/%Y %H:%M:%S" : "%d/%m/%Y"
    return str_date.strftime(fmt)
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
