class Product < ActiveRecord::Base
  validates_uniqueness_of :code
  validates_presence_of :name, :code
  validates_length_of :code, :name, :within => 3..40
end
