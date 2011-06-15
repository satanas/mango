require 'test_helper'

class HopperTest < ActiveSupport::TestCase
  def setup
    @hopper = Hopper.new :number=>1
  end

  test "null" do
    @hopper = Hopper.new
    assert !@hopper.save, "Hopper saved in blank: #{@hopper.inspect}"
    assert_error_length(2, @hopper)
  end

  test "valid" do
    @hopper.number = 'asd'
    assert !@hopper.save, "Hopper saved with invalid number: #{@hopper.inspect}"
    assert_error_length(1, @hopper)
    @hopper.number = -1
    assert !@hopper.save, "Hopper saved with out of range number: #{@hopper.inspect}"
    assert_error_length(1, @hopper)
  end
end
