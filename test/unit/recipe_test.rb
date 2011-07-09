require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @recipe = Recipe.new :code=>'00001', :name=>'Recipe', :version=>'1', :total=>1.99
    @recipe2 = Recipe.new :code=>'00002', :name=>'Recipe', :version=>'2', :total=>2.00
  end
  
  test "blank" do
    @recipe = Recipe.new
    assert !@recipe.save, "Recipe saved in blank: #{@recipe.inspect}"
    assert_error_length(3, @recipe)

    @recipe.code = '00003'
    @recipe.name = 'Recipe'
    @recipe.version = '1'
    @recipe.total = 1.99
    @recipe.add_ingredient(:ingredient=>'10103999 ING DE PRUEBA', :amount=>10, :priority=>1, :percentage=>10)
    assert @recipe.save, "Recipe should be valid and save: #{@recipe.errors.inspect}"
  end
  
  test "length" do
    #@recipe.code = '1'
    @recipe.name = 'R'
    assert !@recipe.save, "Recipe saved with invalid name: #{@recipe.inspect}"
    assert_error_length(2, @recipe)
  end
  
  test "total numericality" do
    @recipe.total = 'abc'
    assert !@recipe.save, "Recipe saved with invalid total: #{@recipe.inspect}"
    assert_error_length(2, @recipe)
  end

  test "import and uniqueness" do
    #assert @recipe2.save
    #assert !@recipe2.save, "Recipe with same code saved twice... #{@recipe.inspect}"
  end
end
