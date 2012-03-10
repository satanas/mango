class ProductLot < ActiveRecord::Base
  belongs_to :order

  validates_uniqueness_of :code
  validates_presence_of :date, :order_id
  validates_length_of :code, :within => 3..20
end
