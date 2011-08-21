class Lot < ActiveRecord::Base
  belongs_to :ingredient
  belongs_to :hopper
  
  validates_uniqueness_of :code
  validates_presence_of :location, :date, :ingredient_id
  validates_length_of :code, :within => 3..20
end
