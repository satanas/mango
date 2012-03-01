class BaseUnit < ActiveRecord::Base
  has_many :product
  has_many :ingredient
  has_many :display_unit
end
