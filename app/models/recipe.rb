class Recipe < ActiveRecord::Base
  has_many :order
  has_many :ingredient_recipe

  validates_presence_of :name, :code
  validates_uniqueness_of :code
  validates_length_of :name, :within => 3..40
  validates_numericality_of :total

  before_validation :check_total

  def eliminate
    self.ingredient_recipe.each do |i|
      i.destroy
    end
    self.destroy
  end

  def add_ingredient(args)
    overwrite = args[:overwrite]
    icode = args[:ingredient].split(' ')[0]
    iname = args[:ingredient][(icode.length + 1)..args[:ingredient].length]
    ingredient = Ingredient.find_by_code(icode)
    if ingredient.nil?
      logger.info("  - El ingrediente no existe. Se crea")
      ingredient = Ingredient.new :code => icode, :name => iname
      ingredient.save
    end
    item = IngredientRecipe.find :first, :conditions=>{:ingredient_id=>ingredient.id, :recipe_id=>self.id}
    if item.nil?
      item = IngredientRecipe.new
      item.ingredient_id = ingredient.id
      item.amount = args[:amount]
      item.priority = args[:priority]
      item.percentage = args[:percentage]
      self.ingredient_recipe << item
    else
      item.amount = args[:amount]
      item.priority = args[:priority]
      item.percentage = args[:percentage]
      item.save if overwrite
    end
  end

  def import(upload)
    if upload.nil?
      errors.add(:upload_file, "Debe seleccionar un archivo")
      return false
    end

    @line = 0
    begin
      transaction do
        overwrite = (upload['overwrite'] == '1') ? true : false
        name =  upload['datafile'].original_filename
        logger.info("Importando el archivo #{name}")
        tmpfile = Tempfile.new "recipe"
        filepath = tmpfile.path()
        # write the file
        tmpfile.write(upload['datafile'].read)
        tmpfile.close()

        fd = File.open(filepath, 'r')
        continue = validate_field(fd, 'Formula')

        while (continue)
          validate_field(fd, 'Code')
          validate_field(fd, '')
          validate_field(fd, 'Description')
          validate_field(fd, '')
          validate_field(fd, 'Date')
          validate_field(fd, 'Stored')
          validate_field(fd, '')
          validate_field(fd, 'Ver')
          header = validate_header(fd)
          @recipe = Recipe.find_by_code(header[:code])
          if @recipe.nil?
            @recipe = Recipe.new(header)
            logger.info("Creando encabezado de receta #{@recipe.inspect}")
          end
          validate_field(fd, nil)
          while (true)
            item = validate_ingredient(fd, overwrite)
            break if item.nil?
            logger.info("  * Ingrediente: #{item.inspect}")
            @recipe.add_ingredient(item)
          end
          @line += 1
          @recipe.total = fd.gets().strip().to_f
          @recipe.save
          @line += 1
          continue = fd.gets().strip()
          break if continue.nil? or continue == '='
        end
      end
    rescue SyntaxError => ex
      errors.add(:syntax, "#{@line}. #{ex.message}")
      return false
    rescue Exception => ex
      errors.add(:unknown, ex.message)
      return false
    end
    return true
  end

  private

  def check_total
    self.total = 0 if self.total.nil?
  end

  def validate_field(fd, value)
    field = fd.gets().strip()
    @line += 1
    return '' if value.nil?
    raise SyntaxError.new "Se esperaba el campo '#{value}' y se obtuvo '#{field}'" if field != value
    return field
  end

  def validate_header(fd)
    header = fd.gets().split(/\t/)
    @line += 1
    raise SyntaxError.new 'Encabezado mal formado' if header.size < 4
    return {
      :code=>header[0], 
      :name=>header[1], 
      :version=>header[3].strip()
    }
  end

  def validate_ingredient(fd, overwrite)
    item = fd.gets().split(/\t/)
    @line += 1
    return nil if item[0].strip() == '-----------'
    raise SyntaxError.new 'Ingrediente mal formado' if item.size < 4
    amount = item[0].gsub('.', '')
    amount = item[0].gsub(',', '.')
    percentage = item[3].strip().gsub('.', '')
    percentage = item[3].gsub(',', '.')
    return {
      :amount=>amount.to_f, 
      :percentage=>percentage.to_f, 
      :ingredient=>item[2].strip(),
      :priority=>0,
      :overwrite=>overwrite
    }
  end
end
