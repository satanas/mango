ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  
  def print_errors(num, obj)
    return "Expected #{num} errors, got #{obj.errors.size}. #{obj.errors.inspect}"
  end

  def assert_error_length(num, obj)
    assert !obj.save, "Saved #{obj.class.to_s} unexpectedly - #{obj.inspect}"
    assert_equal obj.errors.size, num, print_errors(num, obj)
  end
  
  def assert_error_match(obj, field, match)
    assert_match match, obj.errors[field].to_s, "Not matched the expected error, #{obj.errors.inspect}"
  end
  
  def assert_invalid(obj, field, wrong_val, right_val, match)
    obj[field] = wrong_val
    assert !obj.save, "#{obj.class.to_s} saved with #{field.to_s} invalid - #{obj.inspect}"
    assert_equal 1, obj.errors.length, "A field which wasn't supposed to be affected gave error - #{obj.errors.inspect}"
    assert_error_match obj, field, match
    obj[field] = right_val
  end
  
  # this function resumes the last step of a test
  def assert_obj_saved(obj)
    assert obj.save, "#{obj.class.to_s} not saved - #{obj.errors.inspect}"
  end
end
