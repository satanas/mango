class IngredientRecipe < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :recipe

  validates_presence_of :amount
  validates_numericality_of :amount

  validates_associated :ingredient, :recipe

  #before_validation :validate_existence
  before_validation :fill_values

  def fill_values
    self.percentage = 0 if self.percentage.nil?
    self.priority = 0 if self.priority.nil?
  end

  def validate_existence
    if IngredientRecipe.find(:first, :conditions => ["ingredient_id = ? and recipe_id = ?", self.ingredient_id, self.recipe_id])
      errors.add_to_base("ingredient already exist")
    end
    return (errors.size > 0) ? false : true
  end
end
