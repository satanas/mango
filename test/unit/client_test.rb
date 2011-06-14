require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def setup
    @client = Client.new
  end

  test "blank" do
    assert !@client.save
    assert @client.errors.length == 7, @client.errors.inspect
  end
end
