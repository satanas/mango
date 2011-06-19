require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @product = Product.new
  end
  
  test "blank" do
    # Test code and name presence, name and code length
    assert !@product.save, "Product saved in blank: #{@product.inspect}"
    assert_error_length(4, @product)
  end
  
  test "length" do
    # Test name length and code length
    @product.code = '0'
    @product.name = 'T'*50
    assert !@product.save, "Product saved with invalid field lengths: #{@product.inspect}"
    assert_error_length(2, @product)
  end
  
  test "uniqueness" do
    # Test code uniqueness
    @product.code = '0000001'
    @product.name = 'Test-1'
    assert !@product.save, "Product saved a record with non-unique code: #{@product.inspect}"
    assert_error_length(1, @product)
  end
end
