require 'test_helper'

class IngredientRecipeTest < ActiveSupport::TestCase
  fixtures :ingredients
  def setup
    @item = IngredientRecipe.new :amount=>12.35, :priority=>14, :percentage=>1.99
  end
  
  test "blank" do
    @item = IngredientRecipe.new
    assert !@item.save, "IngredientRecipe saved in blank: #{@item.inspect}"
    assert_equal @item.errors.length, 6, "Expected 6 errors. Got: #{@item.errors.length} - #{@item.errors.inspect}"
  end
end
