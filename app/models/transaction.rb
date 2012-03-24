class Transaction < ActiveRecord::Base
  belongs_to :transaction_type
  belongs_to :warehouse
  belongs_to :user

  validates_numericality_of :amount
  validates_presence_of :amount, :date, :transaction_type_id, :warehouse_id

  before_save :create_code

  private

  def create_code
    last = Transaction.last
    if last.nil?
      self.code = '00000001'
    else
      self.code = last.code.succ
    end
  end
end
