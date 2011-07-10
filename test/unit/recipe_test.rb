require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @recipe = Recipe.new :code=>'00007', :name=>'Recipe', :version=>'1', :total=>1.99
    @recipe2 = Recipe.new :code=>'00009', :name=>'Recipe', :version=>'2', :total=>2.00
  end
  
  test "blank" do
    @recipe = Recipe.new
    assert_error_length 3, @recipe
  end
  
  test "length" do
    assert_invalid @recipe, :name, 'R', 'My recipe', /is too short/
    assert_obj_saved @recipe
  end
  
  test "total numericality" do
    assert_invalid @recipe, :total, 'abc', 1, /is not a number/
    assert_obj_saved @recipe
  end

  test "import and uniqueness" do
    assert @recipe.import("#{RAILS_ROOT}/test/receta_brill_una.txt", true), @recipe.errors.inspect
    assert !@recipe.import("#{RAILS_ROOT}/test/receta_brill_error.txt", true)
  end
end
