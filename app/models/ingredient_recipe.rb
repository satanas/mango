class IngredientRecipe < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :recipe
  
  validates_presence_of :amount, :percentage
  validates_numericality_of :priority, :only_integer => true
  validates_numericality_of :amount, :percentage

  validates_associated :ingredient, :recipe
  
  #before_validation :validate_existence
  
  def validate_existence
    if IngredientRecipe.find(:first, :conditions => ["ingredient_id = ? and recipe_id = ?", self.ingredient_id, self.recipe_id])
      errors.add_to_base("ingredient already exist")
    end
    return (errors.size > 0) ? false : true
  end
end
