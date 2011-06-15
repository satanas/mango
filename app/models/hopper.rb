class Hopper < ActiveRecord::Base
  validates_presence_of :number
  validates_numericality_of :number, :only_integer => true, :greater_than_or_equal_to => 0
end
