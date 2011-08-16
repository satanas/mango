class Ingredient < ActiveRecord::Base
  has_many :ingredient_recipe
  has_many :hopper_ingredient
  has_many :lot

  validates_uniqueness_of :code
  validates_presence_of :name, :code
  validates_length_of :code, :name, :within => 3..40
end
