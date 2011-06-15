require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new :name=>'Test', :login=>'test', :password=>'12345', :password_confirmation=>'12345'
    @user2 = User.new :name=>'Test2', :login=>'test2', :password=>'12345', :password_confirmation=>'12345'
  end
  
  test "blank" do
    @user = User.new
    assert !@user.save, "User saved in blank: #{@user.inspect}"
    assert_error_length(4, @user)
    @user.name = 'Test'
    @user.login= 'test'
    assert !@user.save, "User saved without password and confirmation: #{@user.inspect}"
    assert_error_length(2, @user)
    @user.password = '12345'
    @user.password_confirmation = '12345'
    assert @user.save, "User not saved #{@user.inspect} - #{@user.errors.inspect}"
  end
  
  test "password mismatch" do
    @user.password_confirmation = '54321'
    assert !@user.save, "User saved with password_confirmation non-identical: #{@user.inspect}"
    assert_error_length(1, @user)
  end
  
  test "length" do
    @user.name = 'T'
    @user.login= 't'
    assert !@user.save, "User saved with name and login too short: #{@user.inspect}"
    assert_error_length(2, @user)
    @user.name = 'Test'
    @user.login= 'test'
    @user.password = '123'
    @user.password_confirmation = '123'
    assert !@user.save, "User saved with password too short: #{@user.inspect}"
    assert_error_length(1, @user)
    @user.password = '12345'
    @user.password_confirmation = '12345'
    assert @user.save, "User not saved #{@user.inspect} - #{@user.errors.inspect}"
  end
  
  test "login uniqueness" do
    @user.login= 'prueba'
    assert !@user.save, "User saved with prueba non-unique: #{@user.inspect}"
    assert_error_length(1, @user)
    @user.login= 'prueba2'
    assert @user.save
  end
end
