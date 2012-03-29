class Transaction < ActiveRecord::Base
  belongs_to :transaction_type
  belongs_to :warehouse
  belongs_to :user

  validates_numericality_of :amount
  validates_presence_of :amount, :date, :transaction_type_id, :warehouse_id

  before_save :create_code
  after_save :increase_stock
  after_destroy :decrease_stock

  private

  def create_code
    last = Transaction.last
    if last.nil?
      self.code = '00000001'
    else
      self.code = last.code.succ
    end
  end

  def increase_stock
    warehouse = Warehouse.get(self.warehouse.id)
    warehouse.stock += self.amount
    warehouse.save
  end

  def decrease_stock
    warehouse = Warehouse.get(self.warehouse.id)
    warehouse.stock -= self.amount
    warehouse.save
  end
end
