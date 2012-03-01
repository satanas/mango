class Transaction < ActiveRecord::Base
  belongs_to :transaction_type
  belongs_to :warehouse
  belongs_to :user
end
