require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  def setup
    @ingredients = Ingredient.new
  end
  
  test "blank" do
    # Test code and name presence, name and code length
    assert !@ingredients.save
    assert_equal @ingredients.errors.length, 4
  end
  
  test "length" do
    # Test name length and code length
    @ingredients.code = '0'
    @ingredients.name = 'T'
    assert !@ingredients.save
    assert_equal @ingredients.errors.length, 2
    @ingredients.code = '0'*50
    @ingredients.name = 'T'*50
    assert !@ingredients.save
    assert_equal @ingredients.errors.length, 2
    @ingredients.code = '0001'
    @ingredients.name = 'Test Name'
    assert @ingredients.save
  end
  
  test "unicity" do
    # Test code unicity
    @ingredients.code = '10101005'
    @ingredients.name = 'Test-1'
    assert !@ingredients.save
    assert_equal @ingredients.errors.length, 1
    @ingredients.code = '1015'
    @ingredients.name = 'Test-1'
    assert @ingredients.save
  end
end
