class IngredientRecipe < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :recipe
  
  validates_presence_of :amount, :priority, :percentage
  validates_numericality_of :amount, :priority, :percentage
  
  before_validation :validate_existence
  
  def validate_existence
    begin
      ingredient = Ingredient.find(self.ingredient_id)
    rescue Exception => ex
      errors.add(:ingredient_id, "must exist")
    end
    
    begin
      recipe = Recipe.find(self.recipe_id)
    rescue Exception => ex
      errors.add(:recipe_id, "must exist")
    end

    if IngredientRecipe.find(:first, :conditions => ["ingredient_id = ? and recipe_id = ?", self.ingredient_id, self.recipe_id])
      errors.add_to_base("ingredient already exist")
    end
    return (errors.size > 0) ? false : true
  end
end
