require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  def setup
    @ingredient = Ingredient.new
  end
  
  test "blank" do
    # Test code and name presence, name and code length
    assert !@ingredient.save, "Ingredient saved in blank: #{@ingredient.inspect}"
    assert_equal @ingredient.errors.length, 4, "Expected 4 errors. Got: #{@ingredient.errors.length} - #{@ingredient.errors.inspect}"
  end
  
  test "length" do
    # Test name length and code length
    @ingredient.code = '0'
    @ingredient.name = 'T'*50
    assert !@ingredient.save, "Ingredient saved with invalid field lengths: #{@ingredient.inspect}"
    assert_equal @ingredient.errors.length, 2, "Expected 2 errors. Got: #{@ingredient.errors.length} - #{@ingredient.errors.inspect}"
  end
  
  test "uniqueness" do
    # Test code uniqueness
    @ingredient.code = '10101005'
    @ingredient.name = 'Test-1'
    assert !@ingredient.save, "Ingredient saved a record with non-unique code: #{@ingredient.inspect}"
    assert_equal @ingredient.errors.length, 1, "Expected 1 error. Got: #{@ingredient.errors.length} - #{@ingredient.errors.inspect}"
  end
end
