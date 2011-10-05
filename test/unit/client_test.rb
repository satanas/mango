require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def setup
    @client = Client.new :name=>'Test Name', :ci_rif=>'12345678', :address=>'Test address', :tel1=>'1111-1234567', :code => 'CODE'
  end

  test "blank" do
    @client = Client.new
    assert_error_length 7, @client
  end

  test "length" do
    assert_invalid @client, :ci_rif, '1', '12341238', /is too short/
    assert_invalid @client, :name, 'x' * 50, 'Pedro Perez', /is too long/
    assert_obj_saved @client
  end

  test "uniqueness" do
    assert_invalid @client, :ci_rif, '12341234', '12387650', /has already been taken/
    assert_obj_saved @client
  end
end
