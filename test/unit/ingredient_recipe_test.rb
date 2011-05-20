require 'test_helper'

class IngredientRecipeTest < ActiveSupport::TestCase
  
  def setup
    @item = IngredientRecipe.new :amount=>12.35, :priority=>14, :percentage=>1.99
  end
  
  test "blank" do
    @item = IngredientRecipe.new
    assert !@item.save
    assert @item.errors.length, 6
  end
  
  test "existence" do
    @item.ingredient_id = 999
    @item.recipe_id = 999
    assert !@item.save
    assert @item.errors.length, 2
    @ingredient = Ingredient.find_by_code('10101005')
    @recipe = Recipe.find_by_code('00001')
    @item.ingredient = @ingredient
    @item.recipe = @recipe
    assert @item.save
  end
end
