class TransactionType < ActiveRecord::Base
  has_many :transaction

  validates_uniqueness_of :code
  validates_presence_of :code, :description, :sign
end
