require 'test_helper'

class HopperTest < ActiveSupport::TestCase
  def setup
    @hopper = Hopper.new :number=>9
  end

  test "null" do
    @hopper = Hopper.new
    assert_error_length 2, @hopper
  end

  test "valid" do
    assert_invalid @hopper, :number, 'asd', 9, /is not a number/
    assert_invalid @hopper, :number, -1, 9, /must be greater than or equal to 0/
    assert_obj_saved @hopper
  end
end
