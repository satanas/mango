require 'test_helper'

class ClientTest < ActiveSupport::TestCase
  def setup
    @client = Client.new
  end

  test "blank" do
    assert !@client.save
    assert_equal @client.errors.length, 7
  end
end
