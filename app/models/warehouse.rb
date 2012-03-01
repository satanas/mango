class Warehouse < ActiveRecord::Base
  belongs_to :warehouse_type
  has_many :transaction
end
