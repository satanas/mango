class Recipe < ActiveRecord::Base
  has_many :ingredient_recipe

  validates_presence_of :name, :code
  validates_length_of :name, :within => 3..40
  validates_numericality_of :total
  #validates_associated :ingredient_recipe

  before_validation :check_total

  def check_total
    self.total = 0 if self.total.nil?
  end

  def validate_field(field, value)
    field.strip!()
    if field != value
      errors.add(:upload_file, "Archivo inválido")
      return false
    end
    return true
  end

  def import(upload)
    if upload.nil?
      errors.add(:upload_file, "Debe seleccionar un archivo")
      return false
    end
    begin
      transaction do
        name =  upload['datafile'].original_filename
        logger.info("Importando el archivo #{name}")
        tmpfile = Tempfile.new "recipe"
        filepath = tmpfile.path()
        # write the file
        tmpfile.write(upload['datafile'].read)
        tmpfile.close()

        fd = File.open(filepath, 'r')
        continue = fd.gets().strip()
        return false unless validate_field(continue, 'Formula')

        while (continue)
          return false unless validate_field(fd.gets(), 'Code')
          fd.gets()
          return false unless validate_field(fd.gets(), 'Description')
          fd.gets()
          return false unless validate_field(fd.gets(), 'Date')
          return false unless validate_field(fd.gets(), 'Stored')
          fd.gets()
          return false unless validate_field(fd.gets(), 'Ver')
          header = fd.gets().split(/\t/)
          @recipe = Recipe.new :code=>header[0], :name=>header[1]
          logger.info("Creando encabezado de receta #{@recipe.inspect}")
          fd.gets()
          while (true)
            item = fd.gets().split(/\t/)
            break if item[0].strip() == '-----------'
            logger.info("  * Ingrediente: #{item.inspect}")
            @recipe.add_ingredient(
              :amount=>item[0].to_f, 
              :priority=>item[1].to_i, 
              :percentage=>item[3].strip().to_f, 
              :ingredient=>item[2].strip())
          end
          @recipe.total = fd.gets().strip().to_f
          @recipe.save
          continue = fd.gets().strip()
          break if continue.nil? or continue == '='
        end
      end
    rescue Exception => ex
      errors.add(:unknown, ex.message)
      return false
    end
    return true
  end

  def add_ingredient(args)
    icode = args[:ingredient].split(' ')[0]
    iname = args[:ingredient][(icode.length + 1)..args[:ingredient].length]
    ingredient = Ingredient.find_by_code(icode)
    if ingredient.nil?
      logger.info("  - El ingrediente no existe. Se crea")
      ingredient = Ingredient.new :code => icode, :name => iname
      ingredient.save
    end
    item = IngredientRecipe.new
    item.ingredient_id = ingredient.id
    item.amount = args[:amount]
    item.priority = args[:priority]
    item.percentage = args[:percentage]
    self.ingredient_recipe << item
  end
end
