class Recipe < ActiveRecord::Base
  has_many :ingredient_recipe

  validates_presence_of :name, :code
  validates_uniqueness_of :code
  validates_length_of :name, :within => 3..40
  validates_numericality_of :total
  #validates_associated :ingredient_recipe

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

  def import(filepath, overwrite)
    begin
      transaction do
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
          @recipe = Recipe.find_by_code(header[0])
          if @recipe.nil?
            @recipe = Recipe.new :code=>header[0], :name=>header[1], :version=>header[3].strip()
            logger.info("Creando encabezado de receta #{@recipe.inspect}")
          end
          fd.gets()
          while (true)
            item = fd.gets().split(/\t/)
            break if item[0].strip() == '-----------'
            logger.info("  * Ingrediente: #{item.inspect}")
            amount = item[0].gsub('.', '')
            amount = item[0].gsub(',', '.')
            percentage = item[3].strip().gsub('.', '')
            percentage = item[3].gsub(',', '.')
            @recipe.add_ingredient(
              :amount=>amount.to_f, 
              :priority=>0, 
              :percentage=>percentage.to_f, 
              :ingredient=>item[2].strip(),
              :overwrite=>overwrite)
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

  private

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
end
