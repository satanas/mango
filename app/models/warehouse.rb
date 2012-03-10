class Warehouse < ActiveRecord::Base
  belongs_to :warehouse_type
  has_many :transaction

  validates_uniqueness_of :code
  validates_presence_of :location
  validates_numericality_of :stock

  before_validation :select_content

  attr_accessor :ing_content_id, :pdt_content_id

  def self.get(id)
    warehouse = Warehouse.find id
    if warehouse.warehouse_type_id == 1
      warehouse.ing_content_id = warehouse.content_id
    elsif warehouse.warehouse_type_id == 2
      warehouse.pdt_content_id = warehouse.content_id
    end
    return warehouse
  end

  private

  def select_content
    if self.warehouse_type_id == 1
      self.errors.add_to_base("Ingredient lot can't be blank") if self.ing_content_id.blank?
      self.content_id = ing_content_id
    elsif self.warehouse_type_id == 2
      self.errors.add_to_base("Product lot can't be blank") if self.pdt_content_id.blank?
      self.content_id = pdt_content_id
    end
  end
end
