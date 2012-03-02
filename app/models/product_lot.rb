class ProductLot < ActiveRecord::Base
  belongs_to :order
end
