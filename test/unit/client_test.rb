require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def setup
    @client = Client.new :name=>'Test Name', :ci_rif=>'12345678', :address=>'Test address', :tel1=>'1111-1234567'
  end

  test "blank" do
    @client = Client.new
    assert !@client.save
    assert_error_length(6, @client)
    @client.name = 'Name Lastname'
    @client.ci_rif = '987654321'
    @client.address = 'A kind of address'
    @client.tel1 = '555-5555555'
    assert @client.save, "Client not saved #{@client.inspect} - #{@client.errors.inspect}"
  end

  test "length" do
    @client.ci_rif = '1'
    @client.name = 'x' * 50
    assert !@client.save, "Client saved with ci_rif too short and name too long: #{@client.inspect}"
    assert_error_length(2, @client)
  end

  test "uniqueness" do
    @client.ci_rif = '12341234'
    assert !@client.save, "Client saved with ci_rif non-unique: #{@client.inspect}"
  end
end
