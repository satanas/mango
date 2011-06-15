require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @recipe = Recipe.new :code=>'00001', :name=>'Recipe', :version=>'1', :total=>1.99
    @recipe2 = Recipe.new :code=>'00002', :name=>'Recipe', :version=>'2', :total=>2.00
  end
  
  test "blank" do
    @recipe = Recipe.new
    assert !@recipe.save, "Recipe saved in blank: #{@recipe.inspect}"
    assert_error_length(6, @recipe)

    @recipe.code = '00001'
    @recipe.name = 'Recipe'
    @recipe.version = '1'
    @recipe.total = 1.99
    assert !@recipe.save, "Recipe saved without ingredients: #{@recipe.inspect} - #{@recipe.ingredient_recipe.inspect}"
    @recipe.add_ingredient(:code=>'10103003', :amount=>10, :priority=>1, :percentage=>10)
    assert @recipe.save, "Recipe should be valid and save: #{@recipe.errors}"
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
  
  test "existence" do
    assert_raise(ActiveRecord::RecordNotFound) {
      @recipe.add_ingredient(:code=>'999999999999', :amount=>1, :priority=>1, :percentage=>12)
    }
    assert !@recipe.save, "Recipe saved without ingredients: #{@recipe.inspect} - #{@recipe.ingredient_recipe.inspect}"
    assert_error_length(1, @recipe)
  end

  # TODO: Test import
end
