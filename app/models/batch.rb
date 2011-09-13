class Batch < ActiveRecord::Base
  belongs_to :order
  belongs_to :hopper
  belongs_to :schedule
  belongs_to :user

  validates_uniqueness_of :order_id, :scope => [:number]
  validates_presence_of :order, :hopper, :schedule, :user, :start, :end
  validates_numericality_of :number, :only_integer => true, :greater_than_or_equal_to => 0
  validates_numericality_of :amount, :greater_than_or_equal_to => 0
  validates_associated :order, :hopper, :schedule, :user
end
