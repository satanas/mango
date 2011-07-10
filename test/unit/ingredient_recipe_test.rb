require 'test_helper'

class IngredientRecipeTest < ActiveSupport::TestCase
  fixtures :ingredients
  def setup
    @item = IngredientRecipe.new :amount=>12.35, :priority=>14, :percentage=>1.99
  end
  
  test "blank" do
    @item = IngredientRecipe.new
    assert_error_length 6, @item
  end
end
