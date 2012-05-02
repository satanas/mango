class ProductLot < ActiveRecord::Base
  belongs_to :product
  has_many :order

  validates_uniqueness_of :code
  validates_presence_of :date, :product_id
  validates_length_of :code, :within => 3..20

  def to_collection_select
    "#{self.product.name} (L: #{self.code})"
  end
end
