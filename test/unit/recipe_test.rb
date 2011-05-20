require 'test_helper'

class RecipeTest < ActiveSupport::TestCase
  def setup
    @recipe = Recipe.new :code=>'00001', :name=>'Recipe', :version=>'1', :total=>1.99
    @recipe2 = Recipe.new :code=>'00002', :name=>'Recipe', :version=>'2', :total=>2.00
  end
  
  test "blank" do
    @recipe = Recipe.new
    assert !@recipe.save
    assert @recipe.errors.length, 7
    @recipe.code = '00001'
    @recipe.name = 'Recipe'
    @recipe.version = '1'
    @recipe.total = 1.99
    assert @recipe.save
  end
  
  #test "code uniqueness" do
  #  assert @recipe.save
  #  @recipe2.code = '00001'
  #  assert !@recipe2.save
  #  assert @recipe2.errors.length, 1
  #end
  
  test "length" do
    #@recipe.code = '1'
    @recipe.name = 'R'
    assert !@recipe.save
    assert @recipe.errors.length, 1
  end
  
  test "total numericality" do
    @recipe.total = 'abc'
    assert !@recipe.save
    assert @recipe.errors.length, 1
  end
end
