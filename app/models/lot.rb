class Lot < ActiveRecord::Base
  belongs_to :ingredient
  
  validates_uniqueness_of :code
  validates_presence_of :amount, :date, :ingredient_id
  validates_length_of :code, :within => 3..20
end
