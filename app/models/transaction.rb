class Transaction < ActiveRecord::Base
  belongs_to :transaction_type
  belongs_to :warehouse
  belongs_to :user

  validates_numericality_of :amount
  validates_presence_of :amount, :date, :transaction_type_id, :warehouse_id, :document_number

  before_save :create_code
  after_save :do_stock_update
  after_destroy :undo_stock_update

  private

  def get_sign
    transaction_type = TransactionType.find(self.transaction_type_id)
    return transaction_type.sign
  end

  def do_stock_update
    if get_sign == '+'
      increase_stock
    else
      decrease_stock
    end
  end

  def undo_stock_update
    if get_sign == '-'
      increase_stock
    else
      decrease_stock
    end
  end

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
