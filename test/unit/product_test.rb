require 'test_helper'

class ProductTest < ActiveSupport::TestCase
  def setup
    @product = Product.new :code=>'123456', :name=>'Producto de prueba'
  end
  
  test "blank" do
    @product = Product.new
    assert_error_length 4, @product
  end
  
  test "length" do
    assert_invalid @product, :code, '0', '0123540', /is too short/
    assert_invalid @product, :name, 'T'*50, 'PRUEBA', /is too long/
    assert_obj_saved @product
  end
  
  test "uniqueness" do
    assert_invalid @product, :code, '0000001', '432184766', /has already been taken/
    assert_obj_saved @product
  end
end
