require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new :name=>'Test', :login=>'test', :password=>'12345', :password_confirmation=>'12345'
    @user2 = User.new :name=>'Test2', :login=>'test2', :password=>'12345', :password_confirmation=>'12345'
  end
  
  test "blank" do
    @user = User.new
    assert_error_length 4, @user
  end
  
  test "password mismatch" do
    @user.password_confirmation = '54321'
    assert !@user.save, "User saved with password_confirmation non-identical: #{@user.inspect}"
    assert_error_length 1, @user
  end
  
  test "length" do
    assert_invalid @user, :name, 'T', 'User Test', /is too short/
    assert_invalid @user, :login, 't', 'test', /is too short/
    @user.password = '123'
    @user.password_confirmation = '123'
    assert !@user.save, "User saved with password too short: #{@user.inspect}"
    assert_error_length 1, @user
    @user.password = '12345'
    @user.password_confirmation = '12345'
    assert_obj_saved @user
  end
  
  test "login uniqueness" do
    assert_invalid @user, :login, 'prueba', 'prueba2', /has already been taken/
    assert_obj_saved @user
  end
end
