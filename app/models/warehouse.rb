class Warehouse < ActiveRecord::Base
  belongs_to :warehouse_type
  has_many :transaction

  validates_uniqueness_of :code
  validates_presence_of :code, :location, :content_id
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

  def self.get_all
    warehouses = []
    Warehouse.all.each do |w|
      if w.warehouse_type_id == 1
        w.ing_content_id = w.content_id
      elsif w.warehouse_type_id == 2
        w.pdt_content_id = w.content_id
      end
      warehouses << w
    end
    return warehouses
  end

  def recalculate
    stock = 0
    transactions = Transaction.find :all, :conditions => {:warehouse_id => self.id}, :include => [:transaction_type]
    transactions.each do |t|
      #puts "#{t.transaction_type.sign}#{t.amount}"
      stock += ("#{t.transaction_type.sign}#{t.amount}".to_f)
    end
    self.stock = stock
    raise StandardError, 'Problem updating warehouse stock' unless self.save
  end

  def get_content
    if self.warehouse_type_id == 1
      return Lot.find self.content_id, :include=>[:ingredient]
    elsif self.warehouse_type_id == 2
      return ProductLot.find self.content_id, :include=>[:product]
    end
  end

  def to_collection_select
    content = get_content
    if self.warehouse_type_id == 1
      return "#{self.code} (#{self.warehouse_type.code}): #{content.ingredient.name}"
    elsif self.warehouse_type_id == 2
      return "#{self.code} (#{self.warehouse_type.code}): #{content.product.name}"
    end
  end

  private

  def select_content
    if self.warehouse_type_id == 1
      if self.ing_content_id.blank?
        self.errors.add_to_base("Ingredient lot can't be blank")
        return false
      end
      self.content_id = ing_content_id
    elsif self.warehouse_type_id == 2
      if self.pdt_content_id.blank?
        self.errors.add_to_base("Product lot can't be blank")
        return false
      end
      self.content_id = pdt_content_id
    end
  end
end
