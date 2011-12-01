require 'test_helper'

class IngredientTest < ActiveSupport::TestCase
  def setup
    @ingredient = Ingredient.new :code=>'4324123', :name=>'INGREDIENTE DE PRUEBA'
  end
  
  test "blank" do
    @ingredient = Ingredient.new
    assert_error_length 4, @ingredient
  end
  
  test "length" do
    assert_invalid @ingredient, :code, '0', '0123540', /is too short/
    assert_invalid @ingredient, :name, 'T'*50, 'PRUEBA', /is too long/
    assert_obj_saved @ingredient
  end
  
  test "uniqueness" do
    assert_invalid @ingredient, :code, '10101005', '432184766', /has already been taken/
    assert_obj_saved @ingredient
  end
end
