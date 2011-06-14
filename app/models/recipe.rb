class Recipe < ActiveRecord::Base
  has_many :ingredient_recipe

  validates_presence_of :name, :version, :total, :ingredient_recipe
  validates_length_of :name, :within => 3..40
  validates_numericality_of :total
  validates_associated :ingredient_recipe

  def import(upload)
    begin
      transaction do
        puts upload.inspect
        name =  upload['datafile'].original_filename
        directory = "public"
        # create the file path
        filepath = File.join(directory, name)
        puts "file: #{filepath}"
        # write the file
        File.open(filepath, "wb") { |f| f.write(upload['datafile'].read) }
        
        fd = File.open(filepath, 'r')
        continue = fd.gets()
        while (continue)
          0.upto(7) { |i| fd.gets() }
          header = fd.gets().split(/\t/)
          @recipe = Recipe.new :version=>header[0], :name=>header[1]
          fd.gets()
          while (true)
            item = fd.gets().split(/\t/)
            puts item.inspect
            break if item[0].strip() == '-----------'
            @recipe.add_ingredient(:amount=>item[0].to_f, :priority=>item[1].to_i, :percentage=>item[3].strip().to_f, :code=>item[2].split(' ')[0])
          end
          @recipe.total = fd.gets().strip().to_f
          @recipe.save
          puts @recipe.inspect, @recipe.errors.inspect
          continue = fd.gets().strip()
          break if continue.nil? or continue == '='
        end
      end
    rescue Exception => ex
      errors.add("Failed to import recipe. Error: #{ex.inspect}")
      return false
    end
    return true
  end

  def add_ingredient(args)
    ingredient = Ingredient.find_by_code(args[:code])
    if ingredient.nil?
      raise ActiveRecord::RecordNotFound, "Ingredient with code #{args[:code]} doesn't exist"
    end
    item = IngredientRecipe.new
    item.ingredient_id = ingredient.id
    item.amount = args[:amount]
    item.priority = args[:priority]
    item.percentage = args[:percentage]
    self.ingredient_recipe << item
  end
end
