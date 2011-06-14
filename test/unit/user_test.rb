require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new :name=>'Test', :login=>'test', :password=>'12345', :password_confirmation=>'12345'
    @user2 = User.new :name=>'Test2', :login=>'test2', :password=>'12345', :password_confirmation=>'12345'
  end
  
  test "blank" do
    @user = User.new
    assert !@user.save
    assert_equal @user.errors.length, 3
    @user.name = 'Test'
    @user.login= 'test'
    assert !@user.save
    assert_equal @user.errors.length, 2
    @user.password = '12345'
    @user.password_confirmation = '12345'
    assert @user.save
  end
  
  test "password mismatch" do
    @user.password_confirmation = '12346'
    assert !@user.save
    assert_equal @user.errors.length, 1
  end
  
  test "length" do
    @user.name = 'T'
    @user.login= 't'
    assert !@user.save
    assert_equal @user.errors.length, 2
    @user.name = 'Test'
    @user.login= 'test'
    @user.password = '123'
    @user.password_confirmation = '123'
    assert !@user.save
    assert_equal @user.errors.length, 1
    @user.password = '12345'
    @user.password_confirmation = '12345'
    assert @user.save
  end
  
  test "login uniqueness" do
    @user.login= 'prueba'
    assert !@user.save
    assert_equal @user.errors.length, 1
    @user.login= 'prueba2'
    assert @user.save
  end
end
